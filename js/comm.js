$(document).ready(function(){
	//초기화
	$("#s_bj_name").on("keydown", function(){
		$("#s_partner_id").val("");
	});

	//볼링장명 자동완성
	$("#s_bj_name").autocomplete({
		source : function(request, response) {
			 $.ajax({
					type: 'post',
					url: "autocomplete.php",
					dataType: "json",
					data: $.param({
						s_bj_name: $("#s_bj_name").val()
					}),
					success: function(data) {
						response(
							$.map(data, function(item) {
								return {
									key: item.partner_id,
									value: item.bj_name
								}
							})
						);
					}
			   });
			},
		minLength: 1,
		focus:function(event, ui) {
			return false;
		},
		select:function(event, ui) {
			$("#s_partner_id").val(ui.item.key);
			$("#s_bj_name").val(ui.item.value);
			return false;
		}
	});

	//플레이어명 자동완성
	$("#s_player_nm").autocomplete({
		source : function(request, response) {
			 $.ajax({
					type: 'post',
					url: "autocomplete2.php",
					dataType: "json",
					data: $.param({
						s_player_nm: $("#s_player_nm").val()
					}),
					success: function(data) {
						response(
							$.map(data, function(item) {
								return {
									key: item.player_id,
									value: item.player_nm
								}
							})
						);
					}
			   });
			},
		minLength: 1,
		focus:function(event, ui) {
			return false;
		},
		select:function(event, ui) {
			$("#s_player_id").val(ui.item.key);
			$("#s_player_nm").val(ui.item.value);
			return false;
		}
	});

	//초기화
	$("#s_com_name").on("keydown", function(){
		$("#s_user_id").val("");
	});

	//제휴업체명 자동완성
	$("#s_com_name").autocomplete({
		source : function(request, response) {
			 $.ajax({
					type: 'post',
					url: "autocomplete3.php",
					dataType: "json",
					data: $.param({
						s_com_name: $("#s_com_name").val()
					}),
					success: function(data) {
						response(
							$.map(data, function(item) {
								return {
									key: item.user_id,
									value: item.com_name
								}
							})
						);
					}
			   });
			},
		minLength: 1,
		focus:function(event, ui) {
			return false;
		},
		select:function(event, ui) {
			$("#s_user_id").val(ui.item.key);
			$("#s_com_name").val(ui.item.value);
			return false;
		}
	});
});

function digit_check(evt){
    var code = evt.which?evt.which:event.keyCode;
    if((code < 48 || code > 57) || code!=188){//0~9 ,
        return false;
    }
}

function decimal_check(event){
 var code = event.keyCode; 
  if ((code >= 48 && code <= 57) || (code >= 96 && code <= 105) || code == 110 || code == 190 || code == 8 || code == 9 || code == 13 || code == 46){
	return true;
  }else{
	return false;
  }
}

function convertSquareMeter(obj, ret){
	if($("#"+obj).val()){
		var pyung = parseFloat($("#"+obj).val())*0.3025;
		//$("#"+ret).val(pyung.toFixed(2));
		$("#"+ret).val(Math.floor(pyung*100)/100);//소수점2째자리
	}
}

//세자리콤마
function comma(str) {
    str = String(str);
    return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}

//콤마없애기
function uncomma(str) {
    str = String(str);
    return str.replace(/[^\d]+/g, '');
}

function inputNumberFormat(obj) {
	if(obj){
		obj.value = comma(uncomma(obj.value));
	}
}



//날짜구하기
var date = new Date();
var curYear = date.getFullYear();//올해
var curMonth = date.getMonth();//이번달
var curDate = date.getDate();//오늘
var curDay = date.getDay();//요일

function makeFullDate(requestYear, requestMonth, requestDate) {
	requestMonth = requestMonth+1;
	if (requestMonth < 10) {
		requestMonth = '0' + requestMonth;
	}

	if (requestDate < 10) {
		requestDate = '0' + requestDate;
	}

	var fullDate = requestYear + '-' + requestMonth + '-' + requestDate;
	return fullDate;
}

//오늘 YYYY-mm-dd
function getToday(){			
	var fullDate = makeFullDate(curYear, curMonth, curDate);

	$("#s_date_start").val(fullDate);
	$("#s_date_end").val(fullDate);
}

//이번주 YYYY-mm-dd
function getThisWeek(){			
	var startOfWeek = new Date(curYear, curMonth, curDate-curDay); 
	var startYear = startOfWeek.getFullYear();
	var startMonth = startOfWeek.getMonth();
	var startDate = startOfWeek.getDate();
	var endOfWeek = new Date(curYear, curMonth, curDate+(6-curDay)) ;
	var endYear = endOfWeek.getFullYear();
	var endMonth = endOfWeek.getMonth();
	var endDate = endOfWeek.getDate();

	var start_dt = makeFullDate(startYear, startMonth, startDate);//이번주 월요일
	var end_dt = makeFullDate(endYear, endMonth, endDate);//이번주 일요일

	$("#s_date_start").val(start_dt);
	$("#s_date_end").val(end_dt);
}

//이번달 YYYY-mm-dd
function getThisMonth(){
	//달의 첫째 날
	var startOfMonth = new Date(curYear, curMonth, 1).getDate();

	//달의 마지막 날
	var endOfMonth = new Date(curYear, curMonth, 0).getDate()+1;
	var start_dt = makeFullDate(curYear, curMonth, startOfMonth);
	var end_dt = makeFullDate(curYear, curMonth, endOfMonth);

	$("#s_date_start").val(start_dt);
	$("#s_date_end").val(end_dt);
}

//페이징호출
function fn_paging(p){
	$("#page").val(p);
	var form = $("#form1")[0];
	form.submit();
}

function fn_address() {
	new daum.Postcode({
		oncomplete: function(data) {
			var fullAddr = '';
			var extraAddr = '';

			if (data.userSelectedType === 'R') {
				fullAddr = data.roadAddress;

			} else {
				fullAddr = data.jibunAddress;
			}

			if(data.userSelectedType === 'R'){
				if(data.bname !== ''){
					extraAddr += data.bname;
				}

				if(data.buildingName !== ''){
					extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
				}

				fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
			}

			//document.getElementById('zipcode').value = data.zonecode;
			//document.getElementById('addr').value = fullAddr;
			//document.getElementById('addr2').focus();
			$("#comAddr").val(fullAddr);
		}
	}).open();
}

//아이디중복확인
function fn_checkid(){
	if($("#userId").val()==""){
		alert("아이디를 입력하세요.");
		$("#userId").focus()
		return;
	}

	$.ajax({
		type: 'post',
		url: "checkid.php",
		dataType: "json",
		data: $.param({
			userId: $("#userId").val()
		}),
		success: function(data) {
			if(data.result=="100"){
				$("#check_result").html("사용가능한 아이디입니다.");
				$("#chk").val("Y");
			}else{
				$("#check_result").html("존재하는 아이디입니다.");
				$("#chk").val("N");
			}
		}
   });
}