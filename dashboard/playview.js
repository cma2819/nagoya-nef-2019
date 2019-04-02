'use strict';

// Replicant
const idx = nodecg.Replicant('idx', {defaultValue: 0});
const run = nodecg.Replicant('run', {defaultValue: {}});
const game = nodecg.Replicant('game', {defaultValue: ""});
const category = nodecg.Replicant('category', {defaultValue: ""});
const runners = nodecg.Replicant('runners', {defaultValue: [{},{}]});
const options = nodecg.Replicant('options', {defaultValue: {}});
const setup = nodecg.Replicant('setup', {defaultValue: {}});

/*
    基本情報の更新
*/
observer.on('update-basic-information', (basicInfo) => {
    // タイトル部
    run.value = {
        idx: basicInfo.idx,
        game: basicInfo.game,
        category: basicInfo.category,
        estimate: basicInfo.estimate,
        platform: basicInfo.platform
    }
});

/*
    走者情報の更新
*/
observer.on('update-runners-info', (runnersInfo) => {
    // 名前が入ってない場合は整形する
    for (var i = 0; i < runnersInfo.length; i++) {
        if (!runnersInfo[i].name) {
            runnersInfo[i] = {};
        }
    }
    runners.value = runnersInfo;
});

/*
    セットアップ用 実績情報の更新
*/
observer.on('update-setup-result', (resultInfo) => {
    setup.value.result = resultInfo;
})

/*
    走者Finish時
*/
observer.on('update-finish-runner', runnerIdx => {
    const time = stopwatch.value.time.formatted;
    runners.value[runnerIdx].time = time;
    observer.trigger('send-time', {time: time, idx: runnerIdx});
})

/*
    走者再開時
*/
observer.on('update-resume-runner', runnerIdx => {
    runners.value[runnerIdx].time = '';
})

/*
    オプション情報の更新
*/
observer.on('update-option', option => {
    // optionのキーに値をセット
    options.value[option.name] = option.checked;
});

/*
    タイマースタート時
*/
observer.on('time-start', () => {
    // 現在日時を取得
    const nowDate = new Date();
    // 文字列に整形
    const date = nowDate.getFullYear() + '/' + paddingBy('0', nowDate.getMonth() + 1, 2) + '/' + paddingBy('0', nowDate.getDate(), 2);
    const time = paddingBy('0', nowDate.getHours(), 2) + ':' + paddingBy('0', nowDate.getMinutes(), 2);
    // 現在のRTAインデックス
    const runIdx = run.value.idx;
    observer.trigger('result-start', runIdx, date, time);
});

/*
    タイマー終了時
*/
observer.on('time-stop', () => {
    // 現在日時を取得
    const nowDate = new Date();
    // 文字列に整形
    const date = nowDate.getFullYear() + '/' + paddingBy('0', nowDate.getMonth() + 1, 2) + '/' + paddingBy('0', nowDate.getDate(), 2);
    const time = paddingBy('0', nowDate.getHours(), 2) + ':' + paddingBy('0', nowDate.getMinutes(), 2);
    // 現在のRTAインデックス
    const runIdx = run.value.idx;
    observer.trigger('result-stop', runIdx, date, time);
});
/*
    共通関数
*/
function fixTimezone(date, diffHour) {
    const dateTimeOffset = parseInt(-1 * date.getTimezoneOffset() / 60);
    // diffHourとの差を求める
    const diffFromDate = diffHour - dateTimeOffset;
    date.setHours(date.getHours() + diffFromDate);
    return date;
}
function secondsFormat(t) {
    const time = parseInt(t);
    const hour = parseInt(time / 3600);
    const minutes = ('0' + parseInt((time / 60) % 60)).slice(-2);
    const seconds = ('0' + parseInt(time % 60)).slice(-2);
    return (hour > 0 ? hour + ':' : '') + minutes + ':' + seconds;
}

function getYmdFromDate(date) {
    const year = paddingBy('0', date.getFullYear(), 4);
    const month = paddingBy('0', date.getMonth() + 1, 2);
    const day = paddingBy('0', date.getDate(), 2);
    return year + '/' + month + '/' + day;
}

function getTimeFromDate(date) {
    const hour = paddingBy('0', date.getHours(), 2);
    const minute = paddingBy('0', date.getMinutes(), 2);
    return hour + ':' + minute;
}

function getTimeFromSeconds(sec) {
    const minute = sec/60;
    const second = paddingBy('0', sec%60, 2);
    return minute + ':' + second;
}

function paddingBy(str, src, num) {
    let base = '';
    for (var i = 0; i < num; i++) {
        base += str;
    }
    return (base + src).slice(num * -1);
}