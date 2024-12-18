import 'package:vania/vania.dart';
import 'package:rahmatrestapi/app/http/controllers/customers_controller.dart';
import 'package:rahmatrestapi/app/http/controllers/orders_controller.dart';
import 'package:rahmatrestapi/app/http/controllers/products_controller.dart';
import 'package:rahmatrestapi/app/http/controllers/productnotes_controller.dart';
import 'package:rahmatrestapi/app/http/controllers/vendors_controller.dart';
import 'package:rahmatrestapi/app/http/controllers/users_controller.dart';
import 'package:rahmatrestapi/app/http/controllers/todos_controller.dart';
import 'package:rahmatrestapi/app/http/controllers/auth_controller.dart';
import 'package:rahmatrestapi/app/http/middleware/authenticate.dart';

class ApiRoute implements Route {
  @override
  void register() {
      Router.group(() { 
      Router.get('/', customerController.listCustomers); 
      Router.post('/', customerController.storeCustomer); 
      Router.get('/{id}', customerController.showCustomer); 
      Router.put('/{id}', customerController.updateCustomer); 
      Router.delete('/{id}', customerController.deleteCustomer); 
    }, prefix: '/customers'); 

    Router.group(() { 
      Router.get('/', ordersController.listOrders); 
      Router.post('/', ordersController.createOrder); 
      Router.get('/{id}', ordersController.showOrder); 
      Router.delete('/{id}', ordersController.deleteOrder); 
    }, prefix: '/orders'); 
 
    Router.group(() { 
      Router.get('/', productsController.listProducts); 
      Router.post('/', productsController.createProduct); 
      Router.get('/{id}', productsController.showProduct); 
      Router.put('/{id}', productsController.editProduct); 
      Router.delete('/{id}', productsController.deleteProduct); 
    }, prefix: '/products'); 
 
    Router.group(() { 
      Router.get('/', productnotesController.listNotes); 
      Router.post('/', productnotesController.createNote); 
      Router.get('/{id}', productnotesController.showNote); 
      Router.put('/{id}', productnotesController.editNote); 
      Router.delete('/{id}', productnotesController.deleteNote); 
    }, prefix: '/product-notes'); 

    Router.group(() { 
      Router.get('/', vendorsController.listVendor); 
      Router.post('/', vendorsController.createVendor); 
      Router.get('/{id}', vendorsController.showVendor); 
      Router.put('/{id}', vendorsController.editVendor); 
      Router.delete('/{id}', vendorsController.deleteVendor); 
    }, prefix: '/vendors'); 

    Router.group((){
      Router.post('/register', authController.register);
      Router.post('/login', authController.login);
    }, prefix: '/auth');

    Router.group(() {
      Router.patch('/update-password', usersController.updatePassword);
      Router.get('/', usersController.index);
    }, prefix: '/user', middleware: [AuthenticateMiddleware()]);

    Router.group(() {
      Router.post('/todo', todosController.store);
    }, prefix: '/user', middleware: [AuthenticateMiddleware()]);
  }
}
