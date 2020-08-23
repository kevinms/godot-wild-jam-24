#!/usr/bin/env python3
import sqlite3
import json

#Tornado Libraries
import tornado.ioloop
import tornado.httpserver
import tornado.web
import tornado.websocket


print("Starting Server")
def dict_factory(cursor, row):
    d = {}
    for idx, col in enumerate(cursor.description):
        d[col[0]] = row[idx]
    return d


class Index(tornado.web.RequestHandler):
    def get(self):
        rdata = {}
        conn = sqlite3.connect("score.db")
        conn.row_factory = dict_factory
        cur = conn.cursor()
        cur.execute("select * from scores order by game_quality limit 5000")
        rows = cur.fetchall()
        rdata["scores"] = rows

        conn.close()
        print(rows)
        self.render("page.html", data=rdata)
        return

class NewScore(tornado.web.RequestHandler):
    def post(self):
        rdata = {}
        rdata["scores"] = []
        data = json.loads(self.request.body.decode('utf-8'))


        conn = sqlite3.connect("score.db")
        conn.row_factory = dict_factory
        cur = conn.cursor()
        u = (data["player_name"], data["spouse_name"], data["baby_name"], data["game_quality"])
        cur.execute("insert into scores (player_name, spouse_name, baby_name, game_quality) values (?,?,?,?)", u)
        conn.commit()
        conn.close()

        self.render("page.html", data=rdata)
        return

class Scores(tornado.web.RequestHandler):
    def get(self):
        output = {}

        conn = sqlite3.connect("score.db")
        conn.row_factory = dict_factory
        cur = conn.cursor()
        cur.execute("select * from scores order by game_quality desc limit 10")
        rows = cur.fetchall()
        output["scores"] = rows
        conn.close()

        self.write(json.dumps(output))
        return

handlers = [
    (r'/', Index),
    (r'/scores', Scores),
    (r'/newscore', NewScore),
]

settings = {
"cookie_secret":"new_super_secret_thingy561616546468461",
#"debug": True,
"xsrf_cookies":False,
}


app = tornado.web.Application(handlers, **settings)
app.listen(6680)
tornado.ioloop.IOLoop.instance().start()
