var table_disaster = null;
var table_safety = null;

/**
 * ------------------------------
 * メディアクエリでDatatableの制御
 * ------------------------------
 */
// 1. 変数mqlにMediaQueryListを格納
const mql = window.matchMedia('(min-width: 577px)');

// 2. メディアクエリに応じて実行したい処理を関数として定義
const handleMediaQuery = function(mql) {

    // 二回目以降の描画の場合、初期化が必要
    if (table_disaster) {
        table_disaster.state.clear();
        table_disaster.destroy();
    }
    if (mql.matches) {
        // 577px以上の場合の処理
        // DataTable
        disasterTable();
    } else {
        // 577px未満の場合の処理
        // DataTable
        disasterTableSmapho();
    }

    // 二回目以降の描画の場合、初期化が必要
    if(document.URL.match(/safeties/)){
        if (table_safety) {
            table_safety.state.clear();
            table_safety.destroy();
        }
        if (mql.matches) {
            // 577px以上の場合の処理
            // DataTable
            safetyTable();
            table_safety.columns.adjust();
        } else {
            // 577px未満の場合の処理
            // DataTable
            safetyTableSmapho();
        }
    }
};

$(document).ready(function(){

    // 3. イベントリスナーを追加（メディアクエリの条件一致を監視）
    //初回だけにする。Datatablesが再定義（再初期化）できない。
    mql.addListener(handleMediaQuery);
    
    // 4. 初回チェックのため関数を一度実行
    handleMediaQuery(mql);

});


/**
 * ------------------------------
 * DataTable
 * ------------------------------
 */
const disasterTable = () => {
    // デフォルトの設定を変更（日本語化）
    $.extend( $.fn.dataTable.defaults, { 
        language: {
            url: "https://cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/Japanese.json"
        } 
    }); 
    // DataTables
    table_disaster = $("#disaster-table").DataTable({
    // 2列目を降順にする ( [ [ 列番号, 昇順降順 ], ... ] の形式) 
        order: [ [ 2, "desc" ] ],
        // 状態を保存する機能をつける
        stateSave: true,
        // 件数切替の値を10～50の10刻みにする
        lengthMenu: [ 15, 30, 45, 60, 75 ],
        // 件数のデフォルトの値を15にする
        displayLength: 15,  
        //scrollX: true,
        //scrollY: false,
        columnDefs: [
            //{ targets: 0, visible: true },
            { targets: 0, width: 100 },
            //{ targets: 1, width: 200 },
            //{ targets: 2, width: 10 },
            { targets: 3, width: 56 },
            { targets: 3, orderable: false } //最後の列はソート機能外す
        ]
    });
    
};

const safetyTable = () => {
    // デフォルトの設定を変更（日本語化）
    $.extend( $.fn.dataTable.defaults, { 
        language: {
            url: "https://cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/Japanese.json"
        } 
    }); 
    
    // フィルタリングhtmlの設定
    $("#safety-table tfoot th").each( function () {
        var title = $(this).text();
        if(title == "安否_フィルタ"){
            var htmltext = "<select id='select-safety'>";
            htmltext += "<option value=''></option>";
            htmltext += "<option value='不明'>不明</option>";
            htmltext += "<option value='無事'>無事</option>";
            htmltext += "<option value='有事'>有事</option>";
            htmltext += "<option value='回復'>回復</option>";
            htmltext += "</select>";
            $(this).html(htmltext);
        }
    } );

    // DataTables
    table_safety = $("#safety-table").DataTable({
    // 5列目を降順にする ( [ [ 列番号, 昇順降順 ], ... ] の形式) 
        order: [ [ 4, "desc" ] ],
        // 状態を保存する機能をつける
        stateSave: true,
        // 件数切替の値を10～50の10刻みにする
        lengthMenu: [ 15, 30, 45, 60, 75 ],
        // 件数のデフォルトの値を50にする
        displayLength: 30,
        //scrollX: true,
        //scrollY: 200,
        columnDefs: [
            //{ targets: 0, visible: true },
            { targets: 0, width: 20 },
            { targets: 0, orderable: false }, //ソート機能外す
            { targets: 1, width: 20 },
            { targets: 1, orderable: false }, //ソート機能外す
            { targets: 2, width: 130 },
            { targets: 3, width: 30 },
            { targets: 4, width: 200 }
            //{ targets: 5, width: 100 },adminのみにしか存在しない列なので・・
            //{ targets: 5, orderable: false }, //ソート機能外す
            //{ targets: 6, width: 80 },
            //{ targets: 6, orderable: false } //ソート機能外す
        ]
    });

    // フィルタリングの実行
    $('#select-safety').on('click', (e) => {
        var selectedValue = $('#select-safety option:selected').val();
        table_safety.column(3).search(selectedValue).draw();
    });

    // バッジ（ラベル）の設定
    setSafetyBadge();
};

const setSafetyBadge = () => {
    // バッジ（ラベル）の設定
    $("#safety-table h5.myself-Safety").each( function () {
        var safetyText = $(this).text();

        switch (safetyText){
            case '不明':
                $(this).attr('class', 'badge badge-secondary')
                break;
            case '無事':
                $(this).attr('class', 'badge badge-primary')
                break;
            case '有事':
                $(this).attr('class', 'badge badge-danger')
                break;
            case '回復':
                $(this).attr('class', 'badge badge-info')
                break;
            default:
                break;
        }
    } );
};


// スマホ用
const disasterTableSmapho = () => {
    // デフォルトの設定を変更（日本語化）
    $.extend( $.fn.dataTable.defaults, { 
        language: {
            url: "https://cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/Japanese.json"
        } 
    }); 
    // DataTables
    table_disaster = $("#disaster-table").DataTable({
    // 3列目を降順にする ( [ [ 列番号, 昇順降順 ], ... ] の形式) 
        order: [ [ 2, "desc" ] ],
        // 状態を保存する機能をつける
        stateSave: true,
        // 件数切替の値を10～50の10刻みにする
        lengthMenu: [ 5, 10, 15, 20, 25 ],
        // 件数のデフォルトの値を5にする
        displayLength: 5,  
        scrollX: true,
        //scrollY: 400,
        columnDefs: [
            //{ targets: 0, visible: true },
            { targets: 0, width: 50 },
            { targets: 1, width: 180 },
            { targets: 2, width: 60 },
            //{ targets: 3, width: 56 },
            { targets: 3, orderable: false } //最後の列はソート機能外す
        ]
    });
};

const safetyTableSmapho = () => {
    // デフォルトの設定を変更（日本語化）
    $.extend( $.fn.dataTable.defaults, { 
        language: {
            url: "https://cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/Japanese.json"
        } 
    }); 
    
    // フィルタリングhtmlの設定
    //scrollXをtrueにしているとonClickのイベントがscrollに取られてしまっているのかも？
    var htmltext = "<p>安否で絞込:</p>";
    htmltext += "<select id='select-safety'>";
    htmltext += "<option value=''></option>";
    htmltext += "<option value='不明'>不明</option>";
    htmltext += "<option value='無事'>無事</option>";
    htmltext += "<option value='有事'>有事</option>";
    htmltext += "<option value='回復'>回復</option>";
    htmltext += "</select>";
    $("#filter-box").html(htmltext);

    // DataTables
    table_safety = $("#safety-table").DataTable({
    // 5列目を降順にする ( [ [ 列番号, 昇順降順 ], ... ] の形式) 
        order: [ [ 4, "desc" ] ],
        // 状態を保存する機能をつける
        //stateSave: true,
        // 件数切替機能 無効
        lengthChange: false,
        // 件数のデフォルトの値を50にする
        displayLength: 50,
        scrollX: true,
        //scrollY: 500,
        columnDefs: [
            { targets: 0, width: 10 },
            { targets: 0, orderable: false }, //ソート機能外す
            { targets: 1, width: 10 },
            { targets: 1, orderable: false }, //ソート機能外す
            { targets: 2, width: 140 },
            { targets: 3, width: 30 },
            { targets: 4, width: 100 }
            //{ targets: 5, width: 120 },adminのみにしか存在しない列なので・・
            //{ targets: 5, orderable: false }, //ソート機能外す
            //{ targets: 6, width: 80 },
            //{ targets: 6, orderable: false } //ソート機能外す
        ]
    });


    // フィルタリングの実行
    // スマホでのselectでは選択しただけではclickイベントが発生しないので、changeイベントも加えた。
    $('#select-safety').on('click change', (e) => {
        var selectedValue = $('#select-safety option:selected').val();
        table_safety.column(3).search(selectedValue).draw();
    });

    // バッジ（ラベル）の設定
    setSafetyBadge();
};

/**
 * ------------------------------
 * ポップオーバー
 * ------------------------------
 */
const popupover = () => {
    $('.avatar')
      .popover({
        placement: 'bottom',
        trigger  : 'hover',
        content  : 'アバター（アイコン）は”Gravatar”で登録できます。'
      });
};

/**
 * ------------------------------
 * メーラー起動
 * ------------------------------
 */
$('#btn-disaster-create').on('click', (e) => {

    var address ="";
    var body ="";

    $(".mailto").each(function(i, emailTag) {
        address += $(emailTag).text() + ","; 
        console.log("emailTag=" + $(emailTag).text() + '; ');
        console.log("address=" + address);
    });

    const subject = '安否確認のお願い';
    const disasterName = $("#disaster-name").val();
    const hostUrl = "https://" + location.host;

    body = '「' + disasterName + '」の安否を登録してください。' + '%0D%0A'; // 「'%0D%0A'」を入れて改行
    body += hostUrl; // 「'%0D%0A'」を入れて改行

    location.href = 'mailto:' + address + '?subject=' + subject + '&body=' + body;
    //window.open(window.location.href, '_blank'); // 新しいタブを開き、ページを表示
    console.log('mailto:' + address + '&subject=' + subject + '&body=' + body);
});

/**
 * ------------------------------
 * その他$(document).ready
 * ------------------------------
 */
$(document).ready(function(){
    //最初のinputにフォーカス当てる
    $('input:visible').eq(0).focus();
    //ポップオーバー
    popupover();
});
