import 'package:vania/vania.dart';
import 'package:rahmatrestapi/app/models/customers.dart'; 
import 'package:rahmatrestapi/app/models/orderitems.dart'; 
import 'package:rahmatrestapi/app/models/orders.dart'; 
import 'package:rahmatrestapi/app/models/products.dart'; 

class OrdersController extends Controller {
  Future<Response> listOrders() async { 
    try { 
      var results = await Order() 
          .query() 
          .join('orderitems', 'orders.order_num', '=', 'orderitems.order_num') 
          .join('products', 'orderitems.prod_id', '=', 'products.prod_id') 
          .join('customers', 'orders.cust_id', '=', 'customers.cust_id') 
          .get(); 
      Map<String, dynamic> orderMap = {}; 
      for (var row in results) { 
        int orderNum = row['order_num']; 
        if (!orderMap.containsKey(orderNum)) { 
          orderMap[orderNum.toString()] = { 
            'order_num': row['order_num'], 
            'order_date': row['order_date'], 
            'customer_id': row['cust_id'], 
            'customer_name': row['cust_name'],
            'created_at': row['created_at'], 
            'updated_at': row['updated_at'], 
            'order_items': [] 
          }; 
        } 
        orderMap[orderNum.toString()]['order_items'].add({ 
            'order_item': row['order_item'], 
            'product_id': row['prod_id'], 
            'product_name': row['prod_name'], 
            'quantity': row['quantity'], 
            'size': row['size'], 
            'created_at': row['created_at'], 
            'updated_at': row['updated_at'], 
          }); 
        } 
      return Response.json({ 
        'success': true, 
        'message': 'Orders found', 
        'data': orderMap.values.toList(), 
      }); 
    } catch (e) { 
      print(e.toString()); 
      return Response.json({ 
        'success': false, 
        'message': 'Failed to get orders', 
        'error': e.toString() 
      }); 
 
    } 
  } 
  Future<Response> create() async { 
    return Response.json({}); 
  } 
  Future<Response> createOrder(Request request) async { 
    try { 
      var orderDate = request.input('order_date'); 
      var customerId = request.input('customer_id'); 
      var isCustomerExist = 
          await Customers().query().where('cust_id', '=', customerId).first(); 
      if (isCustomerExist == null) { 
        return Response.json({ 
          'success': false, 
          'message': 'Customer not found', 
        }); 
      }
      var orderItems = request.input('order_items') as List; 
      if (orderItems.isEmpty) { 
        return Response.json({ 
          'success': false, 
          'message': 'Order items is empty', 
        }); 
      } 
      var orderNum = Order().generateId(); 
      await Order().query().insert({ 
        'order_num': orderNum, 
        'order_date': orderDate, 
        'cust_id': customerId, 
        'created_at': DateTime.now().toIso8601String(), 
        'updated_at': DateTime.now().toIso8601String(), 
      }); 
      List<Map<String, dynamic>> savedOrderItems = []; 
      for (var item in orderItems) { 
        if (item is Map) { 
          var prodId = item['prod_id']; 
          var quantity = item['quantity']; 
          var size = item['size']; 
          if (prodId == null || quantity == null || size == null) { 
            return Response.json({ 
              'success': false, 
              'message': 'Order items is invalid', 
            }); 
          } 
          var isProductExist = 
              await Product().query().where('prod_id', '=', prodId).first(); 
          if (isProductExist == null) { 
            return Response.json({ 
              'success': false, 
              'message': 'Product not found', 
            }); 
          } 
          var orderItemData = { 
            'order_item': OrderItems().generateId(), 
            'order_num': orderNum, 
            'prod_id': isProductExist['prod_id'], 
            'quantity': quantity, 
            'size': size, 
            'created_at': DateTime.now().toIso8601String(), 
            'updated_at': DateTime.now().toIso8601String(), 
          }; 
          await OrderItems().query().insert(orderItemData); 
          savedOrderItems.add(orderItemData); 
        } 
      } 
      return Response.json({ 
        'success': true, 
        'message': 'Order created successfully', 
        'data': { 
          'orders': 
              await Order().query().where('order_num', '=', orderNum).first(), 
          'order_items': savedOrderItems, 
        } 
      }); 
    } catch (e) { 
      return Response.json({ 
        'success': false, 
        'message': 'Failed to create order', 
        'error': e.toString() 
      }); 
    } 
  } 
  Future<Response> showOrder(int id) async { 
    return Response.json({}); 
  } 
  Future<Response> edit(int id) async { 
    return Response.json({}); 
  } 
  Future<Response> update(Request request, int id) async { 
    return Response.json({}); 
  } 
  Future<Response> deleteOrder(int id) async { 
    try { 
      var order = await Order().query().where('order_num', '=', id).first(); 
      if (order == null) { 
        return Response.json({ 
          'success': false, 
          'message': 'Order not found', 
        }); 
      } 
      await OrderItems().query().where('order_num', '=', id).delete(); 
      await Order().query().where('order_num', '=', id).delete(); 
      return Response.json({ 
        'success': true, 
        'message': 'Order deleted successfully', 
      }); 
    } catch (e) { 
      return Response.json({ 
        'success': false, 
        'message': 'Failed to delete order', 
        'error': e.toString() 
      }); 
    } 
  } 
}
final OrdersController ordersController = OrdersController();