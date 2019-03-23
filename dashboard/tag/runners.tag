<runners>
    <h2>Runners</h2>
    <div class="runners">
        <div class="runner" each="{runner, i in runners}">
            <runner-info runner_idx="{i}" data="{runner}"></runner-info>
        </div>
        <div class="buttons">
            <button onclick="{ clearRunners }">クリア</button>
        </div>
    </div>
    <style>
        h3 {
            margin-bottom: 5px;
        }

        div.runner {
            margin: 2px 0px;
            float: left;
        }
        div.runners,
        div#runners-button {
            margin: 10px;
        }

    </style>
    <script>
        // 初期化
        this.runners = opts.runners;
        this.itemlist = opts.itemlist;

        // 走者情報更新
        observer.on('update-runners', idx => {
            const items = itemlist[idx].data[3];
            const runners = items;
            this.runners = runners;
            this.update();
        })

        // 子要素たちの更新を検知する
        observer.on('update-runner', (runneridx, runner) => {
            this.runners[runneridx] = runner;
        });

        // クリアボタン押下時イベントハンドラ
        clearRunners(e) {
            observer.trigger('clear-runners-info');
        }

        // 更新ボタン押下時イベントハンドラ
        /*
        updateRunners(e) {
            observer.trigger('update-runners-info', this.runners);
        }
        */

        observer.on('update-all', () => {
            observer.trigger('update-runners-info', this.runners);
        })
    </script>
</runners>