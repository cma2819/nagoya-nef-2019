<time>
    <table>
        <tr>
            <td class="time {state}"><span></span></td>
            <td class="estimate">目標タイム {estimate}</td>
        </tr>
    </table>
    <style>
        :scope {
            display: block;
        }

        table {
            height: 100%;
            width: 100%;
            border-collapse: collapse;
            position: absolute;
            bottom: 2%;
            table-layout: fixed;
        }

        td {
            width: 50%;
            border-bottom: 2px var(--main-color) solid;
            text-align: center;
            vertical-align: bottom;
            padding: 0;
            margin: 0;
        }

        .time {
            font-weight: bold;
        }

        .not_started {
            color: #aaaaaa;
        }

        .running {
            color: #ffffff;
        }

        .paused,
        .finised {
            color: #ffff22;
        }
    </style>

    <script>
        this.time = opts.time;
        this.state = opts.state;
        this.estimate = opts.estimate;

        // 形式はhh:MM:SS
        observer.on('time-changed', data => {
            this.update({ time: data.time, state: data.state });
        })

        observer.on('update-estimate', estimate => {
            this.estimate = estimate;
            this.update();
        })

    </script>
</time>
