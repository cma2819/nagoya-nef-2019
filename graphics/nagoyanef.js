'use strict'

/* Get Infomation List from configure json (/bundles/cfg/nagoya-nef-2019.json) */
/* 設定ファイル(/bundles/cfg/nagoya-nef-2019.json)から表示情報のリストを取得 */
const itemlist = nodecg.bundleConfig.schedule.items;
//const playerList = nodecg.bundleConfig.playerList;

/* Get Replicant | Replicantを取得 */
const run = nodecg.Replicant('run');
const runners = nodecg.Replicant('runners');
const stopwatch = nodecg.Replicant('stopwatch');
const setup = nodecg.Replicant('setup');

/* Define Observer, it send the data to riot tags */
/* Observerを定義, カスタムタグのマウント時に送信される */
const observer = riot.observable();

// 初期表示
nodecg.readReplicant('run', run => {
    riot.mount('run-info', { run: run });
    nodecg.readReplicant('stopwatch', value => {
        const formatted_time = value.time.formatted.split('.')[0];
        const state = value.state;
        const estimate = run.estimate;
        riot.mount('time', { time: formatted_time, state: state, estimate: estimate });
    })
})
nodecg.readReplicant('runners', runners => {
    riot.mount('player-info', { runners: runners });
})
nodecg.readReplicant('setup', setup => {
    riot.mount('setup', { setup: setup, itemlist: itemlist });
})

// Run情報の更新時
run.on('change', newVal => {
    observer.trigger('update-run-info', newVal);
    observer.trigger('update-estimate', newVal.estimate);
})

// 走者情報の更新時
runners.on('change', newVal => {
    observer.trigger('update:player-info', newVal);
})

// Setup情報更新時
setup.on('change', newVal => {
    observer.trigger('update-setup', newVal);
})

// タイム変更時
stopwatch.on('change', newVal => {
    const formatted_time = newVal.time.formatted.split('.')[0];
    const state = newVal.state;
    observer.trigger('time-changed', { time: formatted_time, state: state });
})

/* Update Information on Play View */
/* プレイ中表示の情報を更新 */
playRun.on('change', (runIdx) => {
    /* Get Information from Run Index | 表示情報をインデックスから取得 */
    const runInfo = runList[runIdx];
    /* Get Index of Player List | プレイヤーリストのインデックス取得 */
    const playerIdxs = runInfo.player;

    /* Update run-info | run-infoタグを更新 */
    const rundata = {}
    rundata.game = runInfo.game;
    rundata.category = runInfo.category;
    rundata.estimate = runInfo.estimate;

    // Trigger the event update:run-info
    // update:run-infoイベントを発火
    observer.trigger('update:run-info', rundata)

    /* Update player-info | player-infoタグを更新 */
    const playerdata = {}
    playerdata.name = runInfo.playername
    const twitters = []
    const twitches = []
    for (var i = 0; i < playerIdxs.length; i++) {
        const player = playerList[playerIdxs[i]];
        twitters.push(player.twitter);
        twitches.push(player.twitch);
    }
    playerdata.twitters = twitters;
    playerdata.twitches = twitches;

    // Trigger the event update:player-info
    // update:player-infoイベントを発火
    observer.trigger('update:player-info', playerdata)
});


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
function paddingBy(str, src, num) {
    let base = '';
    for (var i = 0; i < num; i++) {
        base += str;
    }
    return (base + src).slice(num * -1);
}