<basis>
    <h2>Basic Information</h2>
    <div class="basis-input">
        <div>
            <label>
                <select name="overview" onchange="{changeItem}">
                    <option each="{name, i in overviews}" value="{i}" selected={ i==idx}>{name}</option>
                </select>
            </label>
            <button onclick="{upItem}">▲</button>
            <button onclick="{downItem}">▼</button>
        </div>
        <div>
            <label>ゲーム
                <input type="text" name="game" size="80" value="{game}" />
            </label><br />
            <label>カテゴリ
                <input type="text" name="category" size="80" value="{category}" />
            </label><br />
            <label>目標タイム
                <input type="text" name="estimate" size="20" value="{estimate}" />
            </label>
            <label>機種
                <input type="text" name="platform" size="15" value="{platform}" />
            </label>

        </div>
        <!--
        <div class="buttons">
            <button onclick="{ updateBasicInformation }">更新</button>
        </div>
        -->
    </div>
    <style>
        :scope {
            font-size: 110%;
        }

        div {
            margin: 10px 0px;
            margin-left: 5px;
        }
    </style>

    <script>
        // 初期化
        this.idx = opts.idx || 0;
        this.itemlist = opts.itemlist;
        const gameName = this.itemlist[this.idx].data[0];
        const categoryName = this.itemlist[this.idx].data[1];
        const estimate = secondsFormat(this.itemlist[this.idx].length_t);
        const platform = this.itemlist[this.idx].data[2];
        this.game = gameName;
        this.category = categoryName;
        this.estimate = estimate;
        this.platform = platform;
        // 概要リスト整形
        this.overviews = [];
        for (var i = 0; i < this.itemlist.length; i++) {
            const player = [];
            for (var j = 0; j < this.itemlist[i].data[3].length; j++) {
                player.push(this.itemlist[i].data[3][j].name);
            }
            this.overviews.push(this.itemlist[i].data[0] + ' by ' + player.join('／'));
        }

        // 概要リストの変更を通知
        changeItem(e) {
            const idx = e.currentTarget.value;
            const gameName = this.itemlist[idx].data[0];
            const categoryName = this.itemlist[idx].data[1];
            const estimate = secondsFormat(this.itemlist[idx].length_t);
            const platform = this.itemlist[idx].data[2];
            this.game = gameName;
            this.category = categoryName;
            this.estimate = estimate;
            this.platform = platform;
            observer.trigger('update-runners', idx);
        }

        // 概要リストを上へ
        upItem(e) {
            const idx = parseInt($('select[name="overview"]').val());
            if (idx > 0) {
                this.idx = idx - 1;
                //$('select[name="overview"]').val(idx - 1);
                const gameName = this.itemlist[idx - 1].data[0];
                const categoryName = this.itemlist[idx - 1].data[1];
                const estimate = secondsFormat(this.itemlist[idx - 1].length_t);
                const platform = this.itemlist[idx - 1].data[2];
                this.game = gameName;
                this.category = categoryName;
                this.estimate = estimate;
                this.platform = platform;
                observer.trigger('update-runners', idx - 1);
            }
        }

        // 概要リストを下へ
        downItem(e) {
            const idx = parseInt($('select[name="overview"]').val());
            const maxidx = this.itemlist.length - 1;
            if (idx < maxidx) {
                this.idx = idx + 1;
                //$('select[name="overview"]').val(idx + 1);
                const gameName = this.itemlist[idx + 1].data[0];
                const categoryName = this.itemlist[idx + 1].data[1];
                const estimate = secondsFormat(this.itemlist[idx + 1].length_t);
                const platform = this.itemlist[idx + 1].data[2];
                this.game = gameName;
                this.category = categoryName;
                this.estimate = estimate;
                this.platform = platform;
                observer.trigger('update-runners', idx + 1);
            }
        }

        // 情報の更新をObserverに通知
        observer.on('update-all', () => {
            // リストのインデックス
            const idx = parseInt($('select[name="overview"]').val());
            // ゲーム
            const game = document.getElementsByName('game')[0].value;
            // カテゴリ
            const category = document.getElementsByName('category')[0].value;
            // Estimate
            const estimate = document.getElementsByName('estimate')[0].value;
            // 機種
            const platform = document.getElementsByName('platform')[0].value;

            const basicInfo = {
                'idx': idx,
                'game': game,
                'category': category,
                'estimate': estimate,
                'platform': platform
            };

            observer.trigger('update-basic-information', basicInfo);
        });
    </script>

</basis>