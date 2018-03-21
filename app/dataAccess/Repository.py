import psycopg2


def persistUser(usr):
    conn_string = "host='localhost' dbname='bookratedb' user='olgunerguzel' password='Y0rk6l3nm4n0r'"
    ##params = config()
    ##return psycopg2.connect(**params)
    conn = psycopg2.connect(conn_string)
    cur = conn.cursor()
    cur.callproc('util.add_forumuser',
                 (usr.name,
                  usr.surname,
                  usr.bithdate,
                  usr.genderid,
                  usr.username,
                  usr.email,
                  usr.pasword, '1')),

    conn.commit()
    cur.close()
    conn.close()
