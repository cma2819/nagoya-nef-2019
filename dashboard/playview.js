'use strict'

// Replicant
const idx = nodecg.Replicant('idx', {defaultValue: 0});
const run = nodecg.Replicant('run', {defaultValue: {}});
const game = nodecg.Replicant('game', {defaultValue: ""});
const category = nodecg.Replicant('category', {defaultValue: ""});
const runners = nodecg.Replicant('runners', {defaultValue: [{},{}]});
const options = nodecg.Replicant('options', {defaultValue: {}});

/*
    基本情報の更新
*/
observer.on('update-basic-information', (basicInfo) => {
    // タイトル部
    run.value = {
        idx: basicInfo.idx,
        game: basicInfo.game,
        category: basicInfo.category,
        estimate: basicInfo.estimate
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