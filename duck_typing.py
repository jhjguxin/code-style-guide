class Duck:
  def quack(self): 
    print "Quaaaaaack!"
  def feathers(self): 
    print "The duck has white and gray feathers."
 
class Person:
  def quack(self):
    print "The person imitates a duck."
  def feathers(self): 
    print "The person takes a feather from the ground and shows it."


def in_the_forest(duck):
  duck.quack()
  duck.feathers()
 
def game():
  donald = Duck()
  john = Person()
  in_the_forest(donald)
  in_the_forest(john)
 
game()
