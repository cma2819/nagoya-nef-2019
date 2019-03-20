<runner-info>
    <h3>Runner{opts.runner_idx + 1}</h3>
    <div>
        <input type="text" name="runner-name" placeholder="Player Name" onchange="{ changeName }" value="{ runner.name }" /><br />
        <input type="text" name="runner-name" placeholder="Twitter" onchange="{ changeTwitter }" value="{ runner.twitter }" /><br />
        <input type="text" name="runner-name" placeholder="Twitch" onchange="{ changeTwitch }" value="{ runner.twitch }" /><br />
        <input type="text" name="runner-name" placeholder="NicoNico" onchange="{ changeNico }" value="{ runner.nico }" />
    </div>
    <script>
        // 初期化
        this.runneridx = opts.runner_idx;
        this.runner = opts.data;
        this.runner.enable = opts.data.name ? true : false;

        // 名前変更時イベントハンドラ
        changeName(e) {
            const name = e.currentTarget.value;
            this.runner.name = name;
            this.runner.enable = name ? true : false;
            observer.trigger('update-runner', this.runneridx, this.runner);
        }

        // Twitter変更時イベントハンドラ
        changeTwitter(e) {
            const twitter = e.currentTarget.value;
            this.runner.twitter = twitter;
            observer.trigger('update-runner', this.runneridx, this.runner);
        }

        // Twitch変更時イベントハンドラ
        changeTwitch(e) {
            const twitch = e.currentTarget.value;
            this.runner.twitch = twitch;
            observer.trigger('update-runner', this.runneridx, this.runner);
        }

        // ニコニコ変更時イベントハンドラ
        changeNico(e) {
            const nico = e.currentTarget.value;
            this.runner.nico = nico;
            observer.trigger('update-runner', this.runneridx, this.runner);
        }

        // クリア命令時に発火
        observer.on('clear-runners-info', () => {
            this.runner.name = '';
            this.runner.twitter = '';
            this.runner.twitch = '';
            this.runner.nico = '';
            this.update();
        });

    </script>
</runner-info>

<runner-timer>
    <h3>Runner{opts.runner_idx+1}</h3>
    <label> READY
        <input type="checkbox" name="ready" val="1" onchange="{ changeReadyState }" disabled="{ !runner.enable}" />
    </label>
    <!--
    <input type="text" size="8" readonly="readonly" value="{ time }" disabled="{ !runner.enable }" />
    <button class="runner-finish" onclick="{finish}">Finish</button>
    <button class="runner-resume" onclick="{resume}">Resume</button>
    -->

    <style>
        :scope {
            display: block;
            float: left;
        }
        h3 {
            margin-bottom: 5px;
        }

        label {
            margin-left: 0.5em;
            margin-right: 0.5em;
        }

        input[type="text"] {
            margin: 5px 0.5em;
            text-align: center;
        }

        input[type="number"] {
            width: 2em;
        }

        .runner-finish {
            --button-color: #00cc00;
        }

        .runner-resume {
            --button-color: #cc0000;
        }

        button {
            width: 6em;
            color: var(--button-color);
            border-color: var(--button-color);
        }
    </style>
    <script>
        // 初期化
        this.runner = opts.data;
        this.runneridx = opts.runner_idx;
        this.time = opts.data.time || '-';

        // Readyの命令受信時
        observer.on('ready-all-runners', (state) => {
            document.getElementsByName('ready')[this.runneridx].checked = state;
        });

        // Ready変更時のイベントハンドラ
        changeReadyState(e) {
            const ischecked = e.currentTarget.checked;
            observer.trigger('update-ready', this.runneridx, ischecked);
        }

        finish(e) {
            observer.trigger('update-finish-runner', this.runneridx);
        }

        observer.on('send-time', data => {
            if (data.idx == this.runneridx) {
                this.update({ time: data.time });
            }
        })

        resume(e) {
            this.update({ time: '-' });
            observer.trigger('update-resume-runner', this.runneridx);
        }
    </script>
</runner-timer>