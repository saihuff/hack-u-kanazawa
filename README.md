# Haskellのインストール
https://www.haskell.org/ghcup/ にアクセス, OSごとの指示に従ってインストール

# openCVのインストール
$ pip install opencv-contrib-python

# dlibのインストール
https://www.kkaneko.jp/ai/ubuntu/ubuntu_dlib.html このページを参照

# postgreSQLのインストール
$ sudo apt install postgresql postgresql-contrib

## postgreSQLの起動
$ sudo -u postgres psql

## データベースの設定(psql内で)
ALTER USER postgres PASSWORD 'fumifumiHaskell';

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    password TEXT NOT NULL
);

ALTER TABLE users ADD COLUMN time integer;

CLEATE TABLE users (
             score integer,
             );

ALTER TABLE users ADD COLUMN friends ;

CREATE TABLE friends (
    user_id INT REFERENCES users(id),
    friend_id INT REFERENCES users(id),
    status VARCHAR(50) NOT NULL, -- 例: 'pending', 'accepted', 'blocked'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, friend_id),
    CONSTRAINT unique_friendship UNIQUE (user_id, friend_id)
);

ALTER TABLE friends ADD COLUMN friend integer[];

ALTER TABLE users ADD COLUMN state text;

ALTER TABLE users ADD COLUMN starttime timestamp;

ALTER TABLE users ADD COLUMN sleeptime interval;

ALTER TABLE users ADD COLUMN fellsleep timestamp;

# haskell-appの実行
$ cd ~/(略)/hackukanazawa/haskell-app
$ stack build
$ stack exec haskell-app

# python-appの実行
$ cd ~/(略)/hackukanazawa/python-app
$ python3 app.py
