<setup>
    <div each={detail in details} class="detail">
        <table>
            <tr class="main">
                <th colspan="2"><span>{detail.name[0]}</span><span if="{detail.name[1]}">{detail.name[1]}</span></th>
            </tr>
            <tr class="sub">
                <td class="category"><span>{detail.category[0]}</span><span if="{detail.category[1]}">{detail.category[1]}</span></td>
                <td class="other"><span class="slide runner"><img src="./img/game.png" class="othericon" />{detail.runner}</span>
                    <span class="hidden slide start"><img src="./img/clock.png" class="othericon" />{detail.start}</span></td>
            </tr>
        </table>
    </div>
    <style>
        div {
            overflow-x: hidden;
        }

        div.detail {
            padding: 0.2em;
            margin: 8vh 0;
        }

        table {
            width: 100%;
            margin: 0 auto;
            text-align: left;
        }

        th,
        td {
            padding-left: 0.5em;
        }

        td.category {
            width: 60%;
        }

        td.other {
            width: 40%;
        }
    </style>
    <script>
        this.itemlist = opts.itemlist;
        this.setup = opts.setup;

        // 初期処理
        const setupIdx = parseInt(this.setup.result.idx);
        const diff = this.setup.result.diff;
        // Setupダッシュボードで情報が設定された次のインデックスから表示
        const startIdx = setupIdx + 1;
        this.details = makeDetails(setupIdx, diff, this.itemlist);

        // 表示切替
        const classes = ['.runner', '.start'];
        const hiddenClass = 'hidden';
        const target = '.slide';
        let g_class = 1;
        const classLen = 2;
        setInterval(() => {
            const idx = g_class % 2;
            $(target).addClass(hiddenClass);
            setTimeout(() => {
                $(classes[idx]).removeClass(hiddenClass);
            }, 1000)
            g_class = idx + 1;
        }, 30000);

        observer.on('update-setup', setup => {
            this.setup = setup;
            this.details = makeDetails(parseInt(setup.result.idx), setup.result.diff, this.itemlist);
            this.update();
        })

        function makeDetails(setupIdx, diff, itemlist) {
            // Setupダッシュボードで情報が設定された次のインデックスから表示
            const startIdx = setupIdx + 1;
            const maxIdx = itemlist.length - 1;
            const loop = Math.min((maxIdx - startIdx + 1), 3);
            const details = [];
            for (var i = 0; i < loop; i++) {
                const detail = {};
                detail.name = itemlist[startIdx + i].data[0].split(' ', 2);
                detail.category = itemlist[startIdx + i].data[1].split(' ', 2);
                const runners = [];
                for (var j = 0; j < itemlist[startIdx + i].data[3].length; j++) {
                    runners.push(itemlist[startIdx + i].data[3][j].name);
                }
                detail.runner = runners.join('／');
                const date = new Date((itemlist[startIdx + i].scheduled_t + diff) * 1000);
                const startDate = getYmdFromDate(date);
                const startTime = getTimeFromDate(date);
                detail.start = startDate + ' ' + startTime + '～';
                details.push(detail);
            }
            return details;
        }
    </script>
</setup>