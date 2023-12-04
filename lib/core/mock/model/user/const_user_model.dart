import '../../../../features/auth/register/model/register_request_model.dart';

//?In the backend, because of the problem of adding new users,
//? demo data was used (it can be edited as needed).
final constUserModel = RegisterRequestModel(
    email: 'Velanienurshabrina@gmail.com',
    username: 'Velanie',
    password: 'Val123',
    name: Name(firstname: 'Velanie', lastname: 'Shabrina'),
    address: Address(
        city: 'Semarang',
        street: 'Banjarsari Selatan',
        number: 3,
        zipcode: '12926-3874',
        geolocation: Geolocation(lat: '-37.3159', long: '81.1496')),
    phone: '1-570-236-7033');
