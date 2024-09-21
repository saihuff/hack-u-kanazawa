# haskell-app

# URL

## POST ~/api/register
Content-Type: application/json

{"userName": "<ここにユーザーネーム>", "userPassword": "<ここにパスワード>"}

response -> "User Registerd"

## POST ~/api/login
Content-Type: application/json

{"userName": "<ここにユーザーネーム>", "userPassword": "<ここにパスワード>"}

response | 成功 -> セッション記録, "Login Successfull"
         | 失敗 -> "Login Failed"

## GET ~/api/logout
response -> セッション破棄, "LogOut Success"

## GET ~/api/userdata
response -> {"userDataID":<ユーザーID(整数型)>,"userDataName":"<ユーザーネーム>","userDataPassword":"<パスワード>","userDataScore":<スコア>,"userDataStudyTime":<総勉強時間>}

## POST ~/api/picture
Content-Type: application/json

{"getPicture": "<ここにエンコードした画像データ>"}

response -> {"status": "awake"} or {"status": "asleep"}

## GET ~/api/friendcode
response -> <フレンドコード>

## GET ~/api/registerfriend
Content-Type: application/json

{"friendID": <フレンドコード>}

response -> 成功すれば "friend registerd"

## GET ~/api/friends
response -> ["<フレンド1>", "<フレンド2>", ... , "<フレンドn>"]

## GET ~api/getfriendscore
response -> [["<フレンド1のユーザーネーム>", <フレンド1のスコア>], ["<フレンド2>", <フレンド2のスコア>], ... , ["<フレンドn>", <フレンドnのスコア>]]

## POST ~/api/gamestart
response -> なし
ゲーム開始のセットアップをする

## POST ~/api/gamefinish
resopnse -> "HH:MM:SS"
