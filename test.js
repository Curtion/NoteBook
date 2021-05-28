const shape = {
  radius: 10,
  diameter() {
    return this.radius * 2;
  },
  perimeter: () => 2 * Math.PI * this.radius,
};

shape.diameter.call({ radius: 10 });
console.log(shape.perimeter.call({ radius: 10 }));
console.log(2 * Math.PI * 10);
