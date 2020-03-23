from flask import Flask, render_template

app = Flask(__name__)

@app.route("/")
def index():
  headline = "We can run Flask!!!"
  names = "Tinotte, Maat, Osiris, Isis".split(",")
  new_year = True
  return render_template("index.html", headline = headline, names = names, new_year = new_year)

@app.route("/more")
def more():
  return("more simplest template with return a string")

if __name__ == '__main__':
  app.run()