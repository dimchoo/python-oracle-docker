import oracledb

USER = ''
PASSWORD = ''
HOST = ''
PORT = ''
SID = ''
CONNECTION_DATA = f'{USER}/{PASSWORD}@{HOST}:{PORT}/{SID}'

try:
    oracledb.init_oracle_client()
    with oracledb.connect(CONNECTION_DATA) as connection:
        print(connection, 'success!')
except Exception as e:
    print('Connection failed!')
    print(f'Error:\n{e}')
