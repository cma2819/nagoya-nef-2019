<setup>
    <h2>Setup</h2>
    <h3>Result</h3>
    <div>
        <label>
            <select name="overview-setup" onchange="{changeItem}">
                <option each="{name, i in overviews}" value="{i}" selected={ i==idx}>{name}</option>
            </select>
        </label>
        <button onclick="{upItem}">▲</button>
        <button onclick="{downItem}">▼</button>
    </div>
    <label>進行状況
        <select name="setup-status" onchange="{changeStatus}">
            <option value="start" selected={status=='start' }>開始</option>
            <option value="finish" selected={status=='finish' }>終了</option>
        </select>
    </label>
    <br />
    <label>予定日時
        <input name="scheduledDate" type="text" size="10" value="{scheduledDate}" readonly="readonly" />
        <input name="scheduledTime" type="text" size="5" value="{scheduledTime}" readonly="readonly" />
    </label><br />
    <label>実績日時
        <input name="resultDate" type="text" size="10" value="{resultDate}" onchange="{changeResultDate}" onblur="{formatDate}"
            onfocus="{unformat}" placeholder="yyyymmdd" />
        <input name="resultTime" type="text" size="5" value="{resultTime}" onchange="{changeResultTime}" onblur="{formatTime}"
            onfocus="{unformat}" placeholder="hhmm" /></label>
    <button onclick="{copyToResult}">コピー</button>
    <div class="buttons">
        スケジュールとの時間差：
        <span class="ahead" if="{diff <= 0}">{getTimeFromSeconds(diff)}</span>
        <span class="behind" if="{diff > 0}">+{getTimeFromSeconds(diff)}</span>
        <button onclick="{updateResult}">更新</button>
    </div>

    <style>
        .ahead {
            color: blue;
        }

        .behind {
            color: red;
        }
    </style>
    <script>
        // 初期化
        console.log(opts.data);
        this.idx = opts.data.idx || 0;
        this.status = opts.data.status || 'start';
        this.itemlist = opts.itemlist;
        this.diff = opts.data.diff || 0;

        // 概要リスト整形
        this.overviews = [];
        for (var i = 0; i < this.itemlist.length; i++) {
            const player = [];
            for (var j = 0; j < this.itemlist[i].data[3].length; j++) {
                player.push(this.itemlist[i].data[3][j].name);
            }
            this.overviews.push(this.itemlist[i].data[0] + ' by ' + player.join('／'));
        }

        // 予定日時の設定
        this.scheduled = new Date(this.itemlist[this.idx].scheduled);
        if (this.status == 'finish') {
            this.scheduled.setSeconds(this.scheduled.getSeconds() + this.itemlist[this.idx].length_t);
        }
        this.scheduledDate = getYmdFromDate(this.scheduled);
        this.scheduledTime = getTimeFromDate(this.scheduled);

        // 実績日時の設定
        this.result = new Date();
        this.result.setTime(this.scheduled.getTime() + (this.diff * 1000));
        this.resultDate = getYmdFromDate(this.result);
        this.resultTime = getTimeFromDate(this.result);

        // リスト変更時
        changeItem(e) {
            const idx = e.currentTarget.value;
            this.idx = idx;
            this.scheduled = new Date(this.itemlist[this.idx].scheduled);
            if (this.status == 'finish') {
                this.scheduled.setSeconds(this.scheduled.getSeconds() + this.itemlist[this.idx].length_t);
                console.log(this.scheduled);
            }
            this.scheduledDate = getYmdFromDate(this.scheduled);
            this.scheduledTime = getTimeFromDate(this.scheduled);
        }

        // 進行状況変更時
        changeStatus(e) {
            this.status = e.currentTarget.value;
            this.scheduled = new Date(this.itemlist[this.idx].scheduled);
            if (this.status == 'finish') {
                this.scheduled.setSeconds(this.scheduled.getSeconds() + this.itemlist[this.idx].length_t);
            }
            this.scheduledDate = getYmdFromDate(this.scheduled);
            this.scheduledTime = getTimeFromDate(this.scheduled);
        }

        // 概要リストを上へ
        upItem(e) {
            const idx = parseInt($('select[name="overview-setup"]').val());
            if (idx > 0) {
                this.idx = idx - 1;
                this.scheduled = new Date(this.itemlist[this.idx].scheduled);
                if (this.scheduledStatus == 'finish') {
                    this.scheduled.setSeconds(this.scheduled.getSeconds() + this.itemlist[this.idx].length_t);
                    console.log(this.scheduled);
                }
                this.scheduledDate = getYmdFromDate(this.scheduled);
                this.scheduledTime = getTimeFromDate(this.scheduled);
            }
        }

        // 概要リストを下へ
        downItem(e) {
            const idx = parseInt($('select[name="overview-setup"]').val());
            const maxidx = this.itemlist.length - 1;
            if (idx < maxidx) {
                this.idx = idx + 1;
                this.scheduled = new Date(this.itemlist[this.idx].scheduled);
                if (this.scheduledStatus == 'finish') {
                    this.scheduled.setSeconds(this.scheduled.getSeconds() + this.itemlist[this.idx].length_t);
                    console.log(this.scheduled);
                }
                this.scheduledDate = getYmdFromDate(this.scheduled);
                this.scheduledTime = getTimeFromDate(this.scheduled);
            }
        }

        // 予定日時から実績日時へコピー
        copyToResult(e) {
            this.resultDate = this.scheduledDate;
            this.resultTime = this.scheduledTime;
        }

        // 日付へフォーマット
        formatDate(e) {
            const src = e.currentTarget.value;
            if (src.length == 8) {
                const year = src.substring(0, 4);
                const month = src.substring(4, 6);
                const day = src.substring(6, 8);
                this.resultDate = year + '/' + month + '/' + day;
            }
        }
        // 時刻へフォーマット
        formatTime(e) {
            const src = e.currentTarget.value;
            if (src.length == 4) {
                const hour = src.substring(0, 2);
                const minute = src.substring(2, 4);
                this.resultTime = hour + ':' + minute;
            }
        }
        // フォーマットを戻す
        unformat(e) {
            const src = e.currentTarget.value;
            e.currentTarget.value = src.replace(/[^0-9]/g, '');
        }

        // 更新ボタン押下時
        updateResult(e) {
            const result = {};
            result.idx = this.idx;
            result.status = this.status;
            const ymd = this.resultDate.replace(/\//g, '-');
            const time = this.resultTime + ':00';
            const resultDateFormatted = ymd + 'T' + time + '+09:00';
            result.diff = parseInt((new Date(resultDateFormatted).getTime() - this.scheduled.getTime()) / 1000);
            // Riotタグのdiffも設定する
            this.diff = result.diff;
            observer.trigger('update-setup-result', result);
        }
    </script>
</setup>