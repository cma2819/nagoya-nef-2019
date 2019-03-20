<!-- プレイ中画面RTA情報タグ -->
<run-info>
    <table id="run-table">
        <tr id="run-main">
            <th colspan="2"><span>{game[0]}</span><span if={game[1]}>{game[1]}</span></th>
        </tr>
        <tr id="run-sub">
            <td id="sub-left">{category}</td>
            <td id="sub-right">Wii</td>
        </tr>
    </table>


    <style>
        :scope {
            display: block;
            /*height: 100px;*/
        }

        #run-table {
            table-layout: auto;
            width: 100%;
            margin: 0 auto;
            border-collapse: collapse;
        }

        #run-main {
            text-align: center;
            vertical-align: middle;
        }

        #run-main th {
            border-bottom: 2px var(--main-color) solid;
        }

        #run-sub {
            text-align: center;
            vertical-align: middle;
        }

        td#sub-left {
            border-right: 2px var(--main-color) solid;
        }

        span {
            display: inline-block;
            margin: 0 0.2em;
        }

        span.icon {
            background-color: var(--main-color);
            border-radius: 10px;
            padding: 0px 0.4em;
        }
    </style>
    <script>
        // 初期化
        this.game = opts.run.game.split(' ', 2);
        this.category = opts.run.category;
        this.estimate = opts.run.estimate;

        // Set listener to update values | 値更新時のイベントリスナ定義
        observer.on('update-run-info', (data) => {
            this.game = data.game.split(' ', 2);
            this.category = data.category;
            this.estimate = data.estimate;
            this.update();
        });
    </script>
</run-info>

<!-- プレイ中画面プレイヤー情報タグ -->
<player-info>
    <table id="player-table">
        <tr>
            <th colspan="2">
                Runner
            </th>
        </tr>
        <tr each="{runner in runners}">
            <td class="name">{runner.name}</td>
            <td class="sns">
                <span class="sns_content twitch" if={runner.twitch}><img src="./img/icon_twitch.png" height="24px"
                        width="24px" /> {runner.twitch}</span>
                <span class="sns_content nico" if={runner.nico}><img src="./img/icon_nico.png" height="24px" width="24px" />
                    {runner.nico}</span>
                <span class="sns_content twitter" if={runner.twitter}><img src="./img/icon_twitter.png" height="24px"
                        width="24px" /> {runner.twitter}</span>
            </td>
        </tr>
    </table>
    <!--
        <dl>
            <dt>Runner</dt>
            <span each="{runner in runners}">
                <dd>{runner.name}</dd>
                <dd class="sns"><img src="./img/icon_twitter.png" height="24px" width="24px" />{runner.twitter}</dd>
                <dd class="sns"><img src="./img/icon_twitch.png" height="24px" width="24px" />{runner.twitch}</dd>
            </span>
        </dl>
-->
    <style>
        :scope {
            display: block;
        }

        #player-table {
            width: 100%;
            margin: 0 auto;
        }

        dl {
            margin: 0px;
        }

        th {
            width: 100%;
            border-bottom: 2px var(--main-color) solid;
            text-align: left;
        }

        .name {
            padding-left: 0.5em;
            text-align: left;
        }

        .sns {
            text-align: right;
            vertical-align: bottom;
        }

        .sns_content {
            display: none;
        }
    </style>
    <script>
        // 初期化
        this.runners = opts.runners;

        // Set Listener to update values | 値更新時のイベントリスナ定義
        observer.on('update:player-info', (data) => {
            this.runners = data;
            snsClasses = [];
            for (var i = 0; i < this.runners.length; i++) {
                if (snsClasses.indexOf('twitch') < 0 && this.runners[i].twitch) {
                    snsClasses.push('twitch');
                }
                if (snsClasses.indexOf('nico') < 0 && this.runners[i].nico) {
                    snsClasses.push('nico');
                }
                if (snsClasses.indexOf('twitter') < 0 && this.runners[i].twitter) {
                    snsClasses.push('twitter');
                }
            }
            this.update();
        });

        // SNS情報の切り替え用
        let g_sns = 0;
        let snsClasses = [];
        for (var i = 0; i < this.runners.length; i++) {
            if (snsClasses.indexOf('twitch') < 0 && this.runners[i].twitch) {
                snsClasses.push('twitch');
            }
            if (snsClasses.indexOf('nico') < 0 && this.runners[i].nico) {
                snsClasses.push('nico');
            }
            if (snsClasses.indexOf('twitter') < 0 && this.runners[i].twitter) {
                snsClasses.push('twitter');
            }
        }

        function toggleSns() {
            const next = g_sns % (snsClasses.length);
            if (snsClasses.length != 1) {
                $('.sns_content').fadeOut('slow', () => {
                    setTimeout(() => {
                        $('.' + snsClasses[next]).fadeIn('slow');
                    }, 1000);
                })
                g_sns = next + 1;
            } else {
                $('.' + snsClasses[next]).fadeIn('slow');
            }
        }
        setInterval(toggleSns, 10000);


    </script>
</player-info>

<!-- セットアップ画面情報タグ -->
<setup-info>
    <div>
        <h1>C4RUN RTAリレー</h1>
        <p class="label">Up Next</p>
        <dl>
            <dt>Game</dt>
            <dd>{game}</dd>
            <dt>Category</dt>
            <dd>{category}</dd>
            <dt>Player</dt>
            <dd>{player}</dd>
            <dt>Estimate</dt>
            <dd>{estimate}</dd>
        </dl>
    </div>
    <style>
        div {
            position: absolute;
            top: 50px;
            left: 75px;
            width: 720px;
            border: 4px #ffcd00 solid;
            border-radius: 5px;
            padding: 5px 0.5em;
        }

        h1 {
            font-size: 48px;
        }

        p.label {
            border-bottom: 2px #ffcd00 solid;
            font-size: 24px;
            margin-bottom: 5px;
            text-align: right;
        }

        dl {
            margin: 0px 20px;
            font-size: 28px;
            font-weight: bold;
        }

        dt {
            margin: 0.1em 0px;
        }

        dt {
            padding: 0.1em 0.2em;
            background-color: rgba(255, 205, 0, 1.0);
            border-radius: 0.2em;
            display: inline-block;
            margin-top: 0.25em;
        }

        dd {
            margin: 0px;
            margin-left: 0.5em;
        }
    </style>
    <script>
        // Get Observer | Observerの取得
        this.observer = opts.observer;

        // Set Listener to update values | 値更新時のイベントリスナ定義
        this.observer.on('update:setup-info', (data) => {
            this.game = data.game || 'no game';
            this.category = data.category || 'no category';
            this.player = data.player || 'no player';
            this.estimate = data.estimate || '99:99:99';
            this.update();
        });
    </script>
</setup-info>