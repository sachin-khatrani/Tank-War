class Weapon {
  String name;
  String img;
  int price;
  int quantity;

  Weapon({this.name, this.quantity, this.price}) {
    img = getImage(name);
  }

  String getImage(String weaponName) {
    return 'bomb.png';
  }
}

List<Weapon> weapons = [
  Weapon(name: 'Fire Ball', quantity: 10, price: 20000),
  Weapon(name: 'Fuse Ball',  quantity: 10, price: 20000),
  Weapon(name: 'Large Ball',  quantity: 10, price: 20000),
  Weapon(name: 'Volcano Bomb',  quantity: 10, price: 20000),
  Weapon(name: 'Electric Bomb', quantity: 10, price: 20000),
  Weapon(name: 'Cracker Ball', quantity: 10, price: 20000),
  Weapon(name: 'Jump Ball', quantity: 10, price: 20000),
  Weapon(name: 'Laser Ball', quantity: 10, price: 20000),
  Weapon(name: 'TankJump Ball', quantity: 10, price: 20000),
  Weapon(name: 'Fire Ball', quantity: 10, price: 20000),
];