import 'package:vania/vania.dart';
import 'package:rahmatrestapi/app/models/customers.dart';

class CustomerController extends Controller {
  Future<Response> listCustomers() async {
    try {
      var queryResults = await Customers()
          .query()
          .join('orders', 'customers.cust_id', '=', 'orders.cust_id')
          .join('orderitems', 'orders.order_num', '=', 'orderitems.order_num')
          .get();
      Map<String, dynamic> customerData = {};
      for (var record in queryResults) {
        String customerId = record['cust_id'];
        if (!customerData.containsKey(customerId)) {
          customerData[customerId] = {
            'cust_id': record['cust_id'],
            'cust_name': record['cust_name'],
            'cust_address': record['cust_address'],
            'cust_city': record['cust_city'],
            'cust_zip': record['cust_zip'],
            'cust_country': record['cust_country'],
            'cust_telp': record['cust_telp'],
            'created_at': record['created_at'],
            'updated_at': record['updated_at'],
            'orders': []
          };
        }
        String orderNumber = record['order_num'].toString();
        var existingOrder = customerData[customerId]['orders'].firstWhere(
            (order) => order['order_num'].toString() == orderNumber,
            orElse: () => null);
        if (existingOrder == null) {
          existingOrder = {
            'order_num': record['order_num'],
            'order_date': record['order_date'],
            'created_at': record['created_at'],
            'updated_at': record['updated_at'],
            'order_items': []
          };
          customerData[customerId]['orders'].add(existingOrder);
        }
        existingOrder['order_items'].add({
          'order_item': record['order_item'],
          'prod_id': record['prod_id'],
          'quantity': record['quantity'],
          'size': record['size'],
          'created_at': record['created_at'],
          'updated_at': record['updated_at'],
        });
      }
      return Response.json({
        'success': true,
        'message': 'Customers retrieved successfully',
        'data': customerData.values.toList(),
      });
    } catch (error) {
      return Response.json({
        'success': false,
        'message': 'Error retrieving customers',
        'error': error.toString()
      });
    }
  }
  Future<Response> createCustomer() async {
    return Response.json({});
  }
  Future<Response> storeCustomer(Request request) async {
    try {
      var name = request.input('name');
      var address = request.input('address');
      var city = request.input('kota');
      var zipCode = request.input('zip');
      var country = request.input('country');
      var phone = request.input('telp');
      var customerId = Customers().generateId();
      await Customers().query().insert({
        'cust_id': customerId,
        'cust_name': name,
        'cust_address': address,
        'cust_city': city,
        'cust_zip': zipCode,
        'cust_country': country,
        'cust_telp': phone,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
      var newCustomer = await Customers().query().where('cust_id', '=', customerId).first();
      return Response.json({
        'success': true,
        'message': 'Customer created successfully',
        'data': newCustomer
      });
    } catch (error) {
      return Response.json({
        'success': false,
        'message': 'Error creating customer',
        'error': error.toString()
      });
    }
  }
  Future<Response> showCustomer(String id) async {
    try {
      var customer = await Customers().query().where('cust_id', '=', id).first();
      if (customer == null) {
        return Response.json({
          'success': false,
          'message': 'Customer not found',
        });
      }
      return Response.json({
        'success': true,
        'message': 'Customer found',
        'data': customer,
      });
    } catch (error) {
      return Response.json({
        'success': false,
        'message': 'Error retrieving customer',
        'error': error.toString()
      });
    }
  }
  Future<Response> editCustomer(int id) async {
    return Response.json({});
  }
  Future<Response> updateCustomer(Request request, String id) async {
    try {
      var name = request.input('name');
      var address = request.input('address');
      var city = request.input('kota');
      var zipCode = request.input('zip');
      var country = request.input('country');
      var phone = request.input('telp');

      await Customers().query().where('cust_id', '=', id).update({
        'cust_name': name,
        'cust_address': address,
        'cust_city': city,
        'cust_zip': zipCode,
        'cust_country': country,
        'cust_telp': phone,
        'updated_at': DateTime.now().toIso8601String(),
      });
      var updatedCustomer = await Customers().query().where('cust_id', '=', id).first();
      return Response.json({
        'success': true,
        'message': 'Customer updated successfully',
        'data': updatedCustomer
      });
    } catch (error) {
      return Response.json({
        'success': false,
        'message': 'Error updating customer',
        'error': error.toString()
      });
    }
  }
  Future<Response> deleteCustomer(String id) async {
    try {
      var customer = await Customers().query().where('cust_id', '=', id).first();

      if (customer == null) {
        return Response.json({
          'success': false,
          'message': 'Customer not found',
        });
      }
      await Customers().query().where('cust_id', '=', id).delete();
      return Response.json({
        'success': true,
        'message': 'Customer deleted successfully',
      });
    } catch (error) {
      return Response.json({
        'success': false,
        'message': 'Error deleting customer',
        'error': error.toString()
      });
    }
  }
}
final CustomerController customerController = CustomerController();