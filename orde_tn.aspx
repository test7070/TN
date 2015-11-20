<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr">
	<head>
		<title></title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"></script>
		<script src="css/jquery/ui/jquery.ui.widget.js"></script>
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"></script>
		<script type="text/javascript">
			this.errorHandler = null;
			function onPageError(error) {
				alert("An error occurred:\r\n" + error.Message);
			}
			q_desc = 1;
			q_tables = 's';
			var q_name = "orde";
			var q_readonly = ['txtApv', 'txtNoa', 'txtWorker', 'txtWorker2', 'txtComp', 'txtAcomp', 'txtMoney', 'txtTax', 'txtTotal', 'txtTotalus', 'txtWeight', 'txtSales'];
			var q_readonlys = ['txtTotal', 'txtQuatno', 'txtTheory', 'txtC1', 'txtNotv','textComp','textComp2','textOutcomp','textOutcomp2'];
			
			var bbmNum = [
				['txtMoney', 10, 0, 1], ['txtTax', 10, 0, 1], ['txtTotal', 10, 0, 1],
				['txtTotalus', 10, 2, 1], ['txtWeight', 10, 2, 1], ['txtFloata', 10, 4, 1]
			];
			// 允許 key 小數
			var bbsNum = [
				['txtPrice', 15, 1, 1], ['txtTotal', 15, 0, 1], ['txtWeight', 10, 3, 1],
				['txtMount', 10, 2, 1],['txtRadius', 10, 2, 1], ['txtLengthc', 10, 0, 1], ['txtLengthb', 10, 0, 1], ['txtDime', 10, 0, 1],
				['txtWidth', 10, 0, 1],['txtC1', 10, 2, 1],['txtNotv', 10, 2, 1]
			];
			var bbmMask = [];
			var bbsMask = [['txtStyle', 'A']];
			q_sqlCount = 6;
			brwCount = 6;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'noa';
			//ajaxPath = ""; // 只在根目錄執行，才需設定
			aPop = new Array(
				['txtProductno_', 'btnProduct_', 'ucc', 'noa,product,spec,unit,saleprice', '0txtProductno_,txtProduct_,txtSpec_,txtUnit_,txtPrice_', 'ucc_b.aspx'],
				['txtSalesno', 'lblSales', 'sss', 'noa,namea', 'txtSalesno,txtSales,txtPost', 'sss_b.aspx'],
				//['txtAddr', '', 'view_road', 'memo,zipcode', '0txtAddr,txtPost', 'road_b.aspx'],
				//['txtAddr2', '', 'view_road', 'memo,zipcode', '0txtAddr2,txtPost2', 'road_b.aspx'],
				['txtCno', 'lblAcomp', 'acomp', 'noa,nick,addr', 'txtCno,txtAcomp,txtAddr2,txtCustno', 'acomp_b.aspx'],
				['txtCustno', 'lblCust', 'cust', 'noa,comp,nick,paytype,trantype,tel,fax,zip_comp,addr_comp,salesno,sales', 'txtCustno,txtComp,txtNick,txtPaytype,cmbTrantype,txtTel,txtFax,txtPost,txtAddr,txtSalesno,txtSales', 'cust_b.aspx'],
				['textCno_', 'btnCno_', 'acomp', 'noa,acomp', 'textCno_,textComp_', 'acomp_b.aspx'],
				['textCno2_', 'btnCno2_', 'acomp', 'noa,acomp', 'textCno2_,textComp2_', 'acomp_b.aspx'],
				['textOutcno_', 'btnOutcno_', 'tgg', 'noa,comp', 'textOutcno_,textOutcomp_', 'tgg_b.aspx'],
				['textOutcno2_', 'btnOutcno2_', 'tgg', 'noa,comp', 'textOutcno2_,textOutcomp2_', 'tgg_b.aspx']
			);
			brwCount2 = 9;
			$(document).ready(function() {
				bbmKey = ['noa'];
				bbsKey = ['noa', 'no2'];

				q_brwCount();
				// 計算 合適 brwCount
				q_gt('style', '', 0, 0, 0, '');
				q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
				// q_sqlCount=最前面 top=筆數， q_init 為載入 q_sys.xml 與 q_LIST
				$('#txtOdate').focus();
				q_gt('flors_coin', '', 0, 0, 0, "flors_coin");
			});

			function main() {
				if (dataErr){
					dataErr = false;
					return;
				}
				mainForm(1);
			}

			function sum() {
				if (!(q_cur == 1 || q_cur == 2))
					return;
				$('#cmbTaxtype').val((($('#cmbTaxtype').val()) ? $('#cmbTaxtype').val() : '1'));
				$('#txtMoney').attr('readonly', true);
				$('#txtTax').attr('readonly', true);
				$('#txtTotal').attr('readonly', true);
				$('#txtMoney').css('background-color', 'rgb(237,237,238)').css('color', 'green');
				$('#txtTax').css('background-color', 'rgb(237,237,238)').css('color', 'green');
				$('#txtTotal').css('background-color', 'rgb(237,237,238)').css('color', 'green');

				var t_mount = 0, t_price = 0, t_money = 0, t_moneyus = 0, t_weight = 0, t_total = 0, t_tax = 0,t_lengthc=0;
				var t_mounts = 0, t_prices = 0, t_moneys = 0, t_weights = 0;
				var t_unit = '';
				var t_float = q_float('txtFloata');
				
				for (var j = 0; j < q_bbsCount; j++) {
					t_prices = q_float('txtPrice_' + j);
					//t_mount = q_float('txtMount_' + j);
					t_mount = q_float('txtRadius_' + j)>0?q_float('txtRadius_' + j):q_float('txtMount_' + j);
					t_moneys = round(q_mul(t_prices, t_mount), 0);
					t_money = q_add(t_money, t_moneys);
					$('#txtTotal_' + j).val(FormatNumber(t_moneys));
				}
				
				t_total = t_money;
				t_tax = 0;
				t_taxrate = parseFloat(q_getPara('sys.taxrate')) / 100;
				switch ($('#cmbTaxtype').val()) {
					case '1':
						// 應稅
						t_tax = round(q_mul(t_money, t_taxrate), 0);
						t_total = q_add(t_money, t_tax);
						break;
					case '2':
						//零稅率
						t_tax = 0;
						t_total = q_add(t_money, t_tax);
						break;
					case '3':
						// 內含
						t_tax = q_sub(t_money, round(q_div(t_money, q_add(1, t_taxrate)), 0));
						t_total = t_money;
						t_money = q_sub(t_total, t_tax);
						break;
					case '4':
						// 免稅
						t_tax = 0;
						t_total = q_add(t_money, t_tax);
						break;
					case '5':
						// 自定
						$('#txtTax').attr('readonly', false);
						$('#txtTax').css('background-color', 'white').css('color', 'black');
						t_tax = round(q_float('txtTax'), 0);
						t_total = q_add(t_money, t_tax);
						break;
					case '6':
						// 作廢-清空資料
						t_money = 0, t_tax = 0, t_total = 0;
						break;
					default:
				}

				$('#txtMoney').val(FormatNumber(t_money));
				$('#txtTax').val(FormatNumber(t_tax));
				$('#txtTotal').val(FormatNumber(t_total));
			}
			
			function mainPost() {// 載入資料完，未 refresh 前
				if(r_rank<8){
					q_readonlys = ['txtTotal', 'txtQuatno', 'txtTheory', 'txtC1', 'txtNotv','textComp','textComp2','textOutcomp','textOutcomp2,txtPrice'];
				}
				q_getFormat();
				bbmMask = [['txtDatea', r_picd], ['txtOdate', r_picd]];
				bbsMask = [['txtDatea', r_picd], ['txtStyle', 'A']];
				q_mask(bbmMask);
				q_cmbParse("cmbStype", q_getPara('orde.stype'));
				// 需在 main_form() 後執行，才會載入 系統參數
				//q_cmbParse("cmbCoin", q_getPara('sys.coin'));
				/// q_cmbParse 會加入 fbbm
				q_cmbParse("combPaytype", q_getPara('vcc.paytype'));
				// comb 未連結資料庫
				q_cmbParse("cmbTrantype", q_getPara('sys.tran'));
				q_cmbParse("cmbTaxtype", q_getPara('sys.taxtype'));
				
				$("#combPaytype").change(function(e) {
					if (q_cur == 1 || q_cur == 2)
						$('#txtPaytype').val($('#combPaytype').find(":selected").text());
				});
				
				$("#txtPaytype").focus(function(e) {
					var n = $(this).val().match(/[0-9]+/g);
					var input = document.getElementById("txtPaytype");
					if ( typeof (input.selectionStart) != 'undefined' && n != null) {
						input.selectionStart = $(this).val().indexOf(n);
						input.selectionEnd = $(this).val().indexOf(n) + (n + "").length;
					}
				}).click(function(e) {
					var n = $(this).val().match(/[0-9]+/g);
					var input = document.getElementById("txtPaytype");
					if ( typeof (input.selectionStart) != 'undefined' && n != null) {
						input.selectionStart = $(this).val().indexOf(n);
						input.selectionEnd = $(this).val().indexOf(n) + (n + "").length;
					}
				});

				$('#txtFloata').change(function() {
					sum();
				});
				
				$("#cmbTaxtype").change(function(e) {
					sum();
				});

				$('#txtTax').change(function() {
					sum();
				});
				
				$('#txtAddr').change(function() {
					var t_custno = trim($(this).val());
					if (!emp(t_custno)) {
						focus_addr = $(this).attr('id');
						var t_where = "where=^^ noa='" + t_custno + "' ^^";
						q_gt('cust', t_where, 0, 0, 0, "");
					}
				});
				
				$('#txtAddr2').change(function() {
					var t_custno = trim($(this).val());
					if (!emp(t_custno)) {
						focus_addr = $(this).attr('id');
						var t_where = "where=^^ noa='" + t_custno + "' ^^";
						q_gt('cust', t_where, 0, 0, 0, "");
					}
				});
				
				$('#btnCredit').click(function() {
					if (!emp($('#txtCustno').val())) {
						q_box("z_credit.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";custno='" + $('#txtCustno').val() + "';" + r_accy + ";" + q_cur, 'credit', "95%", "95%", q_getMsg('btnCredit'));
					}
				});
				
				q_gt('process', '', 0, 0, 0, 'GetProcess');
			}

			function q_boxClose(s2) {
				var ret;
				switch (s2[0]) {
					case 'ucc':
					 	var as=getb_ret();
					 	$('#txtProductno_'+pbtn_bseq).val(as[0].noa);
					 	pbtn_bseq='';
					break;
				}/// end Switch
				switch (b_pop) {
					case q_name + '_s':
						q_boxClose2(s2);
						/// q_boxClose 3/4
						break;
				}/// end Switch
				b_pop = '';
			}
			
			//20140523 bbs用sizea的欄位來存 工廠+加工方式 分割方法 工廠編號:工廠名稱@加工方式(逗號分隔);工廠編號2:工廠名稱2@加工方式2(逗號分隔)
			function SetChoice(){
				for(var k=0;k<q_bbsCount;k++){
					//初始化<<Start>>
					$('#checkXmemo_'+k).html(xmemo2);
					$('#checkXmemo2_'+k).html(xmemo2);
					$('#checkOutxmemo_'+k).html(xmemo2);
					$('#checkOutxmemo2_'+k).html(xmemo2);
					if(q_cur==1 || q_cur==2){
						$('#btnChoiceok_'+k).removeAttr('disabled');
						$('#checkXmemo_'+k + ' input[type="checkbox"]').prop('checked',false).removeAttr('disabled');
						$('#textCno_'+k).val('').removeAttr('disabled');
						$('#textComp_'+k).val('');
						$('#checkXmemo2_'+k + ' input[type="checkbox"]').prop('checked',false).removeAttr('disabled');
						$('#textCno2_'+k).val('').removeAttr('disabled');
						$('#textComp2_'+k).val('')
						$('#textOutcno_'+k).val('').removeAttr('disabled');
						$('#textOutcomp_'+k).val('');
						$('#checkOutxmemo2_'+k + ' input[type="checkbox"]').prop('checked',false).removeAttr('disabled');
						$('#textOutcno2_'+k).val('').removeAttr('disabled');
						$('#textOutcomp2_'+k).val('');
					}else{
						$('#btnChoiceok_'+k).attr('disabled','disabled');
						$('#checkXmemo_'+k + ' input[type="checkbox"]').prop('checked',false).attr('disabled','disabled');
						$('#textCno_'+k).val('').attr('disabled','disabled');
						$('#textComp_'+k).val('');
						$('#checkXmemo2_'+k + ' input[type="checkbox"]').prop('checked',false).attr('disabled','disabled');
						$('#textCno2_'+k).val('').attr('disabled','disabled');
						$('#textComp2_'+k).val('')
						$('#checkOutxmemo_'+k + ' input[type="checkbox"]').prop('checked',false).attr('disabled','disabled');
						$('#textOutcno_'+k).val('').attr('disabled','disabled');
						$('#textOutcomp_'+k).val('');
						$('#checkOutxmemo2_'+k + ' input[type="checkbox"]').prop('checked',false).attr('disabled','disabled');
						$('#textOutcno2_'+k).val('').attr('disabled','disabled');
						$('#textOutcomp2_'+k).val('');
					}
					//初始化<<End>>
					try{
						var thisSizea = $.trim($('#txtSizea_'+k).val());
						var xa = $.trim(thisSizea.split('^$^')[0]);
						var xa1 = $.trim(xa.split(';')[0]);
						var xa2 = $.trim(xa.split(';')[1]);
						var xb = $.trim(thisSizea.split('^$^')[1]);
						var xb1 = $.trim(xb.split(';')[0]);
						var xb2 = $.trim(xb.split(';')[1]);
						var thisChoice = '';
						if((xa1 != undefined) && (xa1.length > 0)){
							var thisComp = xa1.split('@')[0];
							$('#textCno_'+k).val($.trim(thisComp.split(':')[0]));
							$('#textComp_'+k).val($.trim(thisComp.split(':')[1]));
							thisChoice = $.trim(xa1.split('@')[1]);
							var Choice_Xmemo = thisChoice.split(',');
							$('#checkXmemo_'+k + ' input[type="checkbox"]').each(function(){
								if($.inArray($(this).val(),Choice_Xmemo) !== -1){
									$(this).prop('checked',true);
								}
							});
						}
						if((xa2 != undefined) && (xa2.length > 0)){
							var thisComp = xa2.split('@')[0];
							$('#textCno2_'+k).val($.trim(thisComp.split(':')[0]));
							$('#textComp2_'+k).val($.trim(thisComp.split(':')[1]));
							thisChoice = $.trim(xa2.split('@')[1]);
							var Choice_Xmemo = thisChoice.split(',');
							$('#checkXmemo2_'+k + ' input[type="checkbox"]').each(function(){
								if($.inArray($(this).val(),Choice_Xmemo) !== -1){
									$(this).prop('checked',true);
								}
							});
						}
						if((xb1 != undefined) && (xb1.length > 0)){
							var thisComp = xb1.split('@')[0];
							$('#textOutcno_'+k).val($.trim(thisComp.split(':')[0]));
							$('#textOutcomp_'+k).val($.trim(thisComp.split(':')[1]));
							thisChoice = $.trim(xb1.split('@')[1]);
							var Choice_Xmemo = thisChoice.split(',');
							$('#checkOutxmemo_'+k + ' input[type="checkbox"]').each(function(){
								if($.inArray($(this).val(),Choice_Xmemo) !== -1){
									$(this).prop('checked',true);
								}
							});
						}
						if((xb2 != undefined) && (xb2.length > 0)){
							var thisComp = xb2.split('@')[0];
							$('#textOutcno2_'+k).val($.trim(thisComp.split(':')[0]));
							$('#textOutcomp2_'+k).val($.trim(thisComp.split(':')[1]));
							thisChoice = $.trim(xb2.split('@')[1]);
							var Choice_Xmemo = thisChoice.split(',');
							$('#checkOutxmemo2_'+k + ' input[type="checkbox"]').each(function(){
								if($.inArray($(this).val(),Choice_Xmemo) !== -1){
									$(this).prop('checked',true);
								}
							});
						}
					}catch(e){
						console.log(e.message);
					}
				}
			}
			
			var xmemo2 = '';
			var memo2number = 0;
			var focus_addr = '';
			var t_uccArray = new Array;
			function q_gtPost(t_name) {/// 資料下載後 ...
				switch (t_name) {
					case 'GetProcess':
						var as = _q_appendData("process", "", true);
						memo2number = as.length;
						xmemo2 += "<table style='width:100%;'>"
						for (var i = 0; i < as.length; i++) {
							if (i % 3 == 0)
								xmemo2 += "<tr style='height: 20px;'>";
							xmemo2 += "<td><input id='checkMemo2" + i + "' type='checkbox' style='float: left;' value='" + as[i].process +"'/><a class='lbl' id='memo2no" + i + "' style='float: left;'>" + as[i].process + "</a></td>"
							if (i % 3 == 3)
								xmemo2 += "</tr>";
						}
						xmemo2 += "</table>"
						SetChoice();
						break;
					case 'refreshEnd2':
						var as = _q_appendData("orde", "", true);
						var obj = $('.control_noa');
						if (as[0] != undefined) {
							for (var i = 0; i < abbm.length; i++) {
								if (abbm[i].noa == as[0].noa) {
									abbm[i].end2 = as[0].end2;
									break;
								}
							}
						}
						refresh(q_recno);
						break;
					case 'getAcomp':
						var as = _q_appendData("acomp", "", true);
						if (as[0] != undefined) {
							$('#txtCno').val(as[0].noa);
							$('#txtAcomp').val(as[0].nick);
							$('#txtAddr2').val(as[0].addr);
						}
						Unlock(1);
						$('#chkIsproj').attr('checked', true);
						$('#txtNoa').val('AUTO');
						
						$('#txtOdate').val(q_date());
						
						$('#txtCno').focus();
						break;
					case 'flors_coin':
						var as = _q_appendData("flors", "", true);
						var z_coin='';
						for ( i = 0; i < as.length; i++) {
							z_coin+=','+as[i].coin;
						}
						if(z_coin.length==0) z_coin=' ';
						
						q_cmbParse("cmbCoin", z_coin);
						if(abbm[q_recno])
							$('#cmbCoin').val(abbm[q_recno].coin);
						
						break;
					case 'flors':
						var as = _q_appendData("flors", "", true);
						if (as[0] != undefined) {
							q_tr('txtFloata',as[0].floata);
							sum();
						}
						break;
					case 'cust':
						var as = _q_appendData("cust", "", true);
						if (as[0] != undefined && focus_addr != '') {
							$('#' + focus_addr).val(as[0].addr_fact);
							focus_addr = '';
						}
						break;
					case q_name:
						t_uccArray = _q_appendData("ucc", "", true);
						if (q_cur == 4)// 查詢
							q_Seek_gtPost();
						break;
				}
			}

			function btnOk() {
				Lock(1, {
					opacity : 0
				});
				if ($('#txtOdate').val().length == 0 || !q_cd($('#txtOdate').val())) {
					alert(q_getMsg('lblOdate') + '錯誤。');
					Unlock(1);
					return;
				}
				for (var i = 0; i < q_bbsCount; i++) {
					/*if (q_float('txtMount_' + i) != 0 && !$('#chkCut_' + i).prop('checked')) {
						$('#chkCut_' + i).prop('checked', true);
					}*/
					$('#btnChoiceok_'+i).click();
				}
				var t_chk;
				
				if (q_cur == 1)
					$('#txtWorker').val(r_name);
				else
					$('#txtWorker2').val(r_name);
					
				sum();
				if ($('#txtCustno').val().length == 0) {
					alert('請輸入' + q_getMsg('lblCust'));
					Unlock(1);
					return;
				}
				
				var s1 = $('#txtNoa').val();
				if (s1.length == 0 || s1 == "AUTO")
					q_gtnoa(q_name, replaceAll(q_getPara('sys.key_orde') + $('#txtOdate').val(), '/', ''));
				else
					wrServer(s1);
			}
			
			function coin_chg() {
				var t_where = "where=^^ ('" + $('#txtDatea').val() + "' between bdate and edate) and coin='"+$('#cmbCoin').find("option:selected").text()+"' ^^";
				q_gt('flors', t_where, 0, 0, 0, "");
			}

			function q_stPost() {
				if (!(q_cur == 1 || q_cur == 2))
					return false;
				q_gt('orde', "where=^^ noa='" + $.trim($('#txtNoa').val()) + "'^^", 0, 0, 0, 'refreshEnd2', r_accy);
				Unlock(1);
			}

			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)
					return;
				q_box('orde_tn_s.aspx', q_name + '_s', "550px", "450px", q_getMsg("popSeek"));
			}
			
			var pbtn_bseq='';
			function bbsAssign() {
				var maxNo2 = 0;
				var tmpNo2 = 0;
				try {
					for (var j = 0; j < q_bbsCount; j++) {
						tmpNo2 = parseInt($.trim($('#txtNo2_' + j).val()).length == 0 ? "0" : $.trim($('#txtNo2_' + j).val()));
						maxNo2 = tmpNo2 > maxNo2 ? tmpNo2 : maxNo2;
					}
				} catch(e) {
					alert('訂序異常。');
				}
				for (var j = 0; j < q_bbsCount; j++) {
					$('#lblNo_' + j).text(j + 1);
					if ($('#txtNo2_' + j).val().length == 0) {
						maxNo2++;
						tmpNo2 = ('00' + maxNo2).substring(('00' + maxNo2).length - 3, ('00' + maxNo2).length);
						$('#txtNo2_' + j).val(tmpNo2);
					}
					
					if (!$('#btnMinus_' + j).hasClass('isAssign')) {
						$('#btnProduct_' + j).click(function() {
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length - 1];
							pbtn_bseq=n;
						});
						
						$('#txtUnit_' + j).focusout(function() {
							if (q_cur == 1 || q_cur == 2)
								sum();
						});
						
						$('#txtRadius_' + j).focusout(function() {
							if (q_cur == 1 || q_cur == 2)
								sum();
						});
						
						$('#txtPrice_' + j).focusout(function() {
							if (q_cur == 1 || q_cur == 2)
								sum();
						});
						
						$('#txtMount_' + j).focusout(function() {
							if (q_cur == 1 || q_cur == 2)
								sum();
						});
						
						$('#btnBorn_' + j).click(function() {
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length - 1];
							t_noa = trim($('#txtNoa').val());
							if (t_noa.length == 0 || t_noa.toUpperCase() == 'AUTO') {
								return;
							} else {
								t_where = "noa='" + $('#txtNoa').val() + "' and no2='" + $('#txtNo2_' + n).val() + "'";
								q_box("z_born.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'born', "95%", "95%", q_getMsg('lblBorn'));
							}
						});
						
						$('#btnChoice_'+j).click(function(){
							SetChoice();
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length-1];

							var isShow = $('#Choice_'+n).is(':visible');
							$('div[id*="Choice_"]').each(function(){
								$(this).hide();
							});
							if(isShow){
								$('#Choice_'+n).hide();
							}else{
								$('#Choice_'+n).show();
							}
							var t_width = 0;
							$('#Choice_'+n+'>div').each(function(){
								if($(this).attr('id')!=('ChoiceOkDiv_'+n)){
									t_width = q_add(t_width,$(this).width());
								}
							});
							$('#ChoiceOkDiv_'+n).css('width',t_width+2);
							$('#choicehr_'+n).css('height',$('#ChoiceBase1_'+n).height());
							var t_left = $('#btnChoice_'+n).offset().left-t_width-5;
							var t_top = $('#btnChoice_'+n).offset().top-18;
							$('#Choice_'+n).css({left:t_left,top:t_top});
						});
						
						$('#btnChoiceok_'+j).click(function(){
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length-1];
							var SaveStr = "";
							var t_cno = $.trim($('#textCno_'+n).val());
							var t_comp = (t_cno.length==0?'':$.trim($('#textComp_'+n).val()));
							var t_outcno = $.trim($('#textOutcno_'+n).val());
							var t_outcomp = (t_outcno.length==0?'':$.trim($('#textOutcomp_'+n).val()));
							var t_choice = '';
							var t_outchoice = '';
							$('#checkXmemo_'+n + ' input[type="checkbox"]').each(function(){
								if($(this).prop('checked')){
									t_choice += $.trim($(this).val())+',';
								}
							});
							$('#checkOutxmemo_'+n + ' input[type="checkbox"]').each(function(){
								if($(this).prop('checked')){
									t_outchoice += $.trim($(this).val())+',';
								}
							});
							var t_cno2 = $.trim($('#textCno2_'+n).val());
							var t_comp2 = (t_cno2.length==0?'':$.trim($('#textComp2_'+n).val()));
							var t_choice2 = '';
							var t_outcno2 = $.trim($('#textOutcno2_'+n).val());
							var t_outcomp2 = (t_outcno2.length==0?'':$.trim($('#textOutcomp2_'+n).val()));
							var t_outchoice2 = '';
							$('#checkXmemo2_'+n + ' input[type="checkbox"]').each(function(){
								if($(this).prop('checked')){
									t_choice2 += $.trim($(this).val())+',';
								}
							});
							$('#checkOutxmemo2_'+n + ' input[type="checkbox"]').each(function(){
								if($(this).prop('checked')){
									t_outchoice2 += $.trim($(this).val())+',';
								}
							});
							SaveStr = t_cno+':'+t_comp+'@'+t_choice+';'+t_cno2+':'+t_comp2+'@'+t_choice2+
									 '^$^'+
									 t_outcno+':'+t_outcomp+'@'+t_outchoice+';'+t_outcno2+':'+t_outcomp2+'@'+t_outchoice2;
							$('#txtSizea_'+n).val(SaveStr);
							$('#Choice_'+n).hide();
						});
						
						$('#btnChoiceclose_'+j).click(function(){
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length-1];
							$('#Choice_'+n).hide();
						});
						
						
						//控制尺寸光標與div顯示與隱藏
						$('#tbbs td').children("input:text").each(function() {
							$(this).focusin(function() {
								if(!($(this).attr('id').split('_')[0]=='txtStyle' || $(this).attr('id').split('_')[0]=='txtMount'))
									$('.tn_style').hide();
							});
						});
						
						$('#txtMount_' + j).select(function() {
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length - 1];
							if (q_cur == 1 || q_cur == 2){
								$('#textLengthb_'+n).focus();
								$('#textLengthb_'+n).select();	
							}
						});
						$('#txtMount_' + j).focus(function() {
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length - 1];
							if (q_cur == 1 || q_cur == 2){
								$('#textLengthb_'+n).focus();
								$('#textLengthb_'+n).select();	
							}
						});
						
						$('#txtStyle_' + j).focusout(function() {
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length - 1];
							if (q_cur == 1 || q_cur == 2) {
								if($('#txtStyle_'+n).val()=='*' || $('#txtStyle_'+n).val()=='+' || $('#txtStyle_'+n).val()=='-'){
									$('.tn_style').hide();//關閉全部
									//代入暫存欄位
									$('#textLengthb_'+n).val($('#txtLengthb_'+n).val());//長
									$('#textWidth_'+n).val($('#txtWidth_'+n).val());//寬
									$('#textLengthc_'+n).val($('#txtLengthc_'+n).val());//片數
									$('#textDime_'+n).val($('#txtDime_'+n).val());//厚
									
									if($('#txtClass_'+n).val().indexOf('^')>0){
										var t_class=$('#txtClass_'+n).val().split('^');
										$('#textLength1_'+n).val(t_class[0]);
										$('#textLength2_'+n).val(t_class[1]);
										$('#textShort1_'+n).val(t_class[2]);
										$('#textShort2_'+n).val(t_class[3]);
									}
									
									$('#tn_style_'+n).show();
									if($('#txtStyle_'+n).val()=='+'){
										$('.tn_dime').show();
									}else{
										$('.tn_dime').hide();
									}
																		
									var SeekF= new Array();
									$('#tn_style_'+n+' div').children("input:text").each(function() {
										if($(this).css("display") != 'none')
											SeekF.push($(this).attr('id'));
									});
									SeekF.push('btnStyleok_'+n);
									$('#tn_style_'+n+' div').children("input:text").each(function() {
										$(this).keydown(function(event) {
											if( event.which == 13 || event.which == 40) {
												$('#'+SeekF[SeekF.indexOf($(this).attr('id'))+1]).focus();
												$('#'+SeekF[SeekF.indexOf($(this).attr('id'))+1]).select();
											}
											if( event.which == 38) {
												$('#'+SeekF[SeekF.indexOf($(this).attr('id'))-1]).focus();
												$('#'+SeekF[SeekF.indexOf($(this).attr('id'))-1]).select();
											}
											if( event.which == 37) {
												$('#'+SeekF[SeekF.indexOf($(this).attr('id'))-1*4]).focus();
												$('#'+SeekF[SeekF.indexOf($(this).attr('id'))-1*4]).select();
											}
											if( event.which == 39) {
												$('#'+SeekF[SeekF.indexOf($(this).attr('id'))+1*4]).focus();
												$('#'+SeekF[SeekF.indexOf($(this).attr('id'))+1*4]).select();
											}
										});
										/*$(this).keyup(function() {
											var tmp=$(this).val();
											tmp=tmp.match(/\d{1,}\.{0,1}\d{0,}/);
											$(this).val(tmp);
										});*/
									});
									$('#textLengthb_'+n).focus();
									$('#textLengthb_'+n).select();
								}else{
									$('#tn_style_'+n).hide();
									$('#txtMount_'+n).focus();
									$('#txtMount_'+n).select();
								}
							}
						});
						
						$('#textLengthb_' + j).change(function() {
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length - 1];
							if (q_cur == 1 || q_cur == 2){
								if($('#txtStyle_'+n).val()=='+'){
									$('#textLength1_'+n).val($('#textLengthb_' + n).val());
									$('#textLength2_'+n).val($('#textLengthb_' + n).val());
								}
							}
						});
						
						$('#textWidth_' + j).change(function() {
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length - 1];
							if (q_cur == 1 || q_cur == 2){
								if($('#txtStyle_'+n).val()=='+'){
									$('#textShort1_'+n).val($('#textWidth_' + n).val());
									$('#textShort2_'+n).val($('#textWidth_' + n).val());
								}
							}
						});
						
						$('#btnStyleok_' + j).click(function() {
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length - 1];
							var t_style=$('#txtStyle_'+n).val();
							var t_lengthb=dec($('#textLengthb_'+n).val());//長
							var t_width=dec($('#textWidth_'+n).val());//寬
							var t_lengthc=dec($('#textLengthc_'+n).val());//片數
							var t_dime=dec($('#textDime_'+n).val());//厚
							
							var t_length1=dec($('#textLength1_'+n).val());//長1
							var t_length2=dec($('#textLength2_'+n).val());//長2
							var t_short1=dec($('#textShort1_'+n).val());//短1
							var t_short2=dec($('#textShort2_'+n).val());//短2
							
							//寫入隱藏txt
							$('#txtLengthb_'+n).val(t_lengthb);
							$('#txtWidth_'+n).val(t_width);
							$('#txtLengthc_'+n).val(t_lengthc);
							$('#txtDime_'+n).val(t_dime);
							$('#txtClass_'+n).val(t_length1+'^'+t_length2+'^'+t_short1+'^'+t_short2);
							
							//103/09/11 數量全部取小數點1位,金額取小數點2位放在radius
							switch (t_style) {
								case '*':
									$('#txtUnit_'+n).val('才');
									$('#txtSpec_'+n).val(t_lengthb+'*'+t_width+'共'+t_lengthc+'片');
									//(長和寬)>3 下一尺 虛才
									//100 125 150 175 200 以25跳
									if(t_lengthb%25>=3){
										t_lengthb=q_mul(Math.ceil(t_lengthb/25),25)
									}else{
										t_lengthb=q_mul(Math.floor(t_lengthb/25),25)
										if(t_lengthb==0)
											t_lengthb=25;
									}
									if(t_width%25>=3){
										t_width=q_mul(Math.ceil(t_width/25),25)
									}else{
										t_width=q_mul(Math.floor(t_width/25),25)
										if(t_width==0)
											t_width=25;
									}
									
									$('#txtMount_'+n).val(round(q_mul(q_mul(q_div(t_lengthb,100),q_div(t_width,100)),t_lengthc),1));	
									$('#txtRadius_'+n).val(round(q_mul(q_mul(q_div(t_lengthb,100),q_div(t_width,100)),t_lengthc),2));	
									break;
								case '+':
									//(長+寬)*2
									/*var t_meter=q_mul(q_mul(q_add(q_div(t_lengthb,100),q_div(t_width,100)),2),t_lengthc);*/
									
									//103/09/11 直接看長+長和短+短
									var t_meter=q_mul(q_add(q_add(q_div(t_length1,100),q_div(t_length2,100)),q_add(q_div(t_short1,100),q_div(t_short2,100))),t_lengthc);
									
									var t_length=0,t_short=0;
									if(t_length1>0) t_length++;
									if(t_length2>0) t_length++;
									if(t_short1>0) t_short++;
									if(t_short2>0) t_short++;
									
									$('#txtMount_'+n).val(round(t_meter,1));	
									$('#txtRadius_'+n).val(round(t_meter,2));
									$('#txtUnit_'+n).val('尺');	
									
									$('#txtMemo_'+n).val(t_length+'長'+t_short+'短');
									$('#txtSpec_'+n).val(t_dime+'mm'+t_lengthb+'*'+t_width+'共'+t_lengthc+'片');
									break;
								case '-':
									//(長*寬)
									var t_meter=q_mul(q_mul(q_div(t_lengthb,100),q_div(t_width,100)),t_lengthc);
									$('#txtMount_'+n).val(round(t_meter,1));	
									$('#txtRadius_'+n).val(round(t_meter,2));
									$('#txtUnit_'+n).val('才');
									$('#txtSpec_'+n).val(t_lengthb+'*'+t_width+'共'+t_lengthc+'片');
									break;
							}/// end Switch
							
							sum();
							$('#tn_style_'+n).hide();
							$('#txtMount_'+n).focus();
							$('#txtMount_'+n).select();
						});
						
					}
				}
				_bbsAssign();
				SetChoice();
			}

			function btnIns() {
				_btnIns();
				$('#cmbTaxtype').val(4);
				Lock(1, {
					opacity : 0
				});
				q_gt('acomp', '', 0, 0, 0, 'getAcomp', r_accy);
			}

			function btnModi() {
				if (emp($('#txtNoa').val()))
					return;
				_btnModi();
				$('#txtOdate').focus();
				sum();
			}

			function btnPrint() {
				 var t_where = "noa='" + $.trim($('#txtNoa').val()) + "'";
                q_box("z_ordep.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, '', "95%", "95%", q_getMsg('popPrint'));
			}

			function wrServer(key_value) {
				var i;
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
				xmlSql = '';
				if (q_cur == 2)
					xmlSql = q_preXml();
				_btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
			}

			
			function bbsSave(as) {
				if (!as['productno'] && !as['product'] && !as['spec'] && !dec(as['total'])) {
					as[bbsKey[1]] = '';
					return;
				}
				q_nowf();
				as['type'] = abbm2['type'];
				as['mon'] = abbm2['mon'];
				as['noa'] = abbm2['noa'];
				as['odate'] = abbm2['odate'];
				as['custno'] = abbm2['custno'];
				as['comp'] = abbm2['comp'];

				if (!as['enda'])
					as['enda'] = '0';
				t_err = '';
				if (as['price'] != null && (dec(as['price']) > 99999999 || dec(as['price']) < -99999999))
					t_err = q_getMsg('msgPriceErr') + as['price'] + '\n';
				if (as['total'] != null && (dec(as['total']) > 999999999 || dec(as['total']) < -99999999))
					t_err = q_getMsg('msgMoneyErr') + as['total'] + '\n';
				if (t_err) {
					alert(t_err);
					return false;
				}
				return true;
			}

			function refresh(recno) {
				_refresh(recno);
				$('input[id*="txtProduct_"]').each(function() {
					var thisId = $(this).attr('id').split('_')[$(this).attr('id').split('_').length - 1];
					$(this).attr('OldValue', $('#txtProductno_' + thisId).val());
				});
			}

			function q_popPost(s1) {
				var ret;
				switch (s1) {
					case 'txtProductno_':
						$('input[id*="txtProduct_"]').each(function() {
							var thisId = $(this).attr('id').split('_')[$(this).attr('id').split('_').length - 1];
							$(this).attr('OldValue', $('#txtProductno_' + thisId).val());
						});
						if (trim($('#txtStyle_' + b_seq).val()).length != 0)
							ProductAddStyle(b_seq);
						$('#txtStyle_' + b_seq).focus();
						break;
					case 'txtCustno':
						$('#txtPost2').val($('#txtPost').val());
						$('#txtAddr2').val($('#txtAddr').val());
						$('#txtContract').focus();
						break;
					case 'txtAddr':
						$('#txtPost2').focus();
						break;
					case 'txtAddr2':
						$('#txtPaytype').focus();
						break;
				}
			}

			function readonly(t_para, empty) {
				_readonly(t_para, empty);
			}

			function btnMinus(id) {
				_btnMinus(id);
				sum();
			}

			function btnPlus(org_htm, dest_tag, afield) {
				_btnPlus(org_htm, dest_tag, afield);
			}

			function btnPlut2(org_htm, dest_tag, afield) {
				//_btnPlus(org_htm, dest_tag, afield);
			}

			function q_appendData(t_Table) {
				return _q_appendData(t_Table);
			}

			function btnSeek() {
				_btnSeek();
			}

			function btnTop() {
				_btnTop();
			}

			function btnPrev() {
				_btnPrev();
			}

			function btnPrevPage() {
				_btnPrevPage();
			}

			function btnNext() {
				_btnNext();
			}

			function btnNextPage() {
				_btnNextPage();
			}

			function btnBott() {
				_btnBott();
			}

			function q_brwAssign(s1) {
				_q_brwAssign(s1);
			}

			function btnDele() {
				_btnDele();
			}

			function btnCancel() {
				_btnCancel();
			}

			function FormatNumber(n) {
				var xx = "";
				if (n < 0) {
					n = Math.abs(n);
					xx = "-";
				}
				n += "";
				var arr = n.split(".");
				var re = /(\d{1,3})(?=(\d{3})+$)/g;
				return xx + arr[0].replace(re, "$1,") + (arr.length == 2 ? "." + arr[1] : "");
			}

			function tipShow() {
				Lock(1);
				tipInit();
				var t_set = $('body');
				t_set.find('.tip').eq(0).show();
				for (var i = 1; i < t_set.data('tip').length; i++) {
					index = t_set.data('tip')[i].index;
					obj = t_set.data('tip')[i].ref;
					msg = t_set.data('tip')[i].msg;
					shiftX = t_set.data('tip')[i].shiftX;
					shiftY = t_set.data('tip')[i].shiftY;
					if (obj.is(":visible")) {
						t_set.find('.tip').eq(index).show().offset({
							top : round(obj.offset().top + shiftY, 0),
							left : round(obj.offset().left + obj.width() + shiftX, 0)
						}).html(msg);
					} else {
						t_set.find('.tip').eq(index).hide();
					}
				}
			}

			function tipInit() {
				tip($('#lblIsproj'), '<a style="color:red;font-size:16px;font-weight:bold;width:500px;display:block;">'+q_getMsg('lblIsproj')+'勾選後達到重量、數量將自動結案，否則需手動結案。</a>',-50,20);
				tip($('#lblEnd'), '<a style="color:red;font-size:16px;font-weight:bold;width:500px;display:block;">手動結案後將不會再匯到裁剪、製管、派車、出貨。</a>',0,-10);
				tip($('#btnBorn_0'), '<a style="color:red;font-size:16px;font-weight:bold;width:200px;display:block;">顯示該訂單的歷史記錄。</a>');
				tip($('#btnCredit'), '<a style="color:red;font-size:16px;font-weight:bold;width:250px;display:block;">查看目前客戶額度。</a>', 15);
			}

			function tip(obj, msg, x, y) {
				x = x == undefined ? 0 : x;
				y = y == undefined ? 0 : y;
				var t_set = $('body');
				if ($('#tipClose').length == 0) {
					//顯示位置在btnTip上
					t_set.data('tip', new Array());
					t_set.append('<input type="button" id="tipClose" class="tip" value="關閉"/>');
					$('#tipClose').css('position', 'absolute').css('z-index', '1001').css('color', 'red').css('font-size', '18px').css('display', 'none').click(function(e) {
						$('body').find('.tip').css('display', 'none');
						Unlock(1);
					});
					$('#tipClose').offset({
						top : round($('#btnTip').offset().top - 2, 0),
						left : round($('#btnTip').offset().left - 15, 0)
					});
					t_set.data('tip').push({
						index : 0,
						ref : $('#tipClose')
					});
				}
				if (obj.data('tip') == undefined) {
					t_index = t_set.find('.tip').length;
					obj.data('tip', t_index);
					t_set.append('<div class="tip" style="position: absolute;z-index:1000;display:none;"> </div>');
					t_set.data('tip').push({
						index : t_index,
						ref : obj,
						msg : msg,
						shiftX : x,
						shiftY : y
					});
				}
			}
		</script>
		<style type="text/css">
			#dmain {
				/*overflow: hidden;*/
			}
			.dview {
				float: left;
				width: 390px;
				border-width: 0px;
			}
			.tview {
				border: 5px solid gray;
				font-size: medium;
				background-color: black;
			}
			.tview tr {
				height: 30px;
			}
			.tview td {
				padding: 2px;
				text-align: center;
				border-width: 0px;
				background-color: #FFFF66;
				color: blue;
			}
			.dbbm {
				float: left;
				width: 800px;
				border-radius: 5px;
			}
			.tbbm {
				padding: 0px;
				border: 1px white double;
				border-spacing: 0;
				border-collapse: collapse;
				font-size: medium;
				color: blue;
				background: #cad3ff;
				width: 100%;
			}
			.tbbm tr {
				height: 35px;
			}
			.tbbm tr td {
				width: 10%;
			}
			.tbbm .tdZ {
				width: 1%;
			}
			.tbbm tr td span {
				float: right;
				display: block;
				width: 5px;
				height: 10px;
			}
			.tbbm tr td .lbl {
				float: right;
				color: black;
				font-size: medium;
			}
			.tbbm tr td .lbl.btn {
				color: #4297D7;
				font-weight: bolder;
			}
			.tbbm tr td .lbl.btn:hover {
				color: #FF8F19;
			}
			.txt.c1 {
				width: 100%;
				float: left;
			}
			.txt.num {
				text-align: right;
			}
			.tbbm td {
				margin: 0 -1px;
				padding: 0;
			}
			.tbbm td input[type="text"] {
				border-width: 1px;
				padding: 0px;
				margin: -1px;
				float: left;
			}
			.tbbm select {
				border-width: 1px;
				padding: 0px;
				margin: -1px;
			}
			.dbbs {
				width: 1960px;
			}
			.tbbs a {
				font-size: medium;
			}
			input[type="text"], input[type="button"] {
				font-size: medium;
			}
			.num {
				text-align: right;
			}
			select {
				font-size: medium;
			}
		</style>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	>
		<div style="overflow: auto;display:block;width:1050px;">
		<!--#include file="../inc/toolbar.inc"-->
		</div>
		<div style="overflow: auto;display:block;width:1280px;">
			<div class="dview" id="dview" >
				<table class="tview" id="tview">
					<tr>
						<td align="center" style="width:20px; color:black;"><a id="vewChk"> </a></td>
						<td align="center" style="width:80px; color:black;"><a id="vewOdate"> </a></td>
						<td align="center" style="width:100px; color:black;"><a id="vewNoa"> </a></td>
						<td align="center" style="width:160px; color:black;"><a id="vewNick"> </a></td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox"/></td>
						<td id="odate" style="text-align: center;">~odate</td>
						<td id="noa" class="control_noa" style="text-align: center;">~noa</td>
						<td id="nick" style="text-align: center;">~nick</td>
					</tr>
				</table>
			</div>
			<div class="dbbm">
				<table class="tbbm" id="tbbm">
					<tr style="height:1px;">
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td class="tdZ"> </td>
					</tr>
					<tr>
						<td><span> </span><a id='lblOdate' class="lbl"> </a></td>
						<td><input id="txtOdate" type="text" class="txt c1"/></td>
						<td><select id="cmbStype" class="txt c1"> </select></td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td><input type="button" id="btnTip" value="?" style="float:right;" onclick="tipShow()"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblAcomp' class="lbl btn"> </a></td>
						<td colspan="4">
							<input id="txtCno" type="text" style="float:left;width:25%;"/>
							<input id="txtAcomp" type="text" style="float:left;width:75%;"/>
						</td>
						<td><span> </span><a id='lblNoa' class="lbl"> </a></td>
						<td colspan="2"><input id="txtNoa" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblCust' class="lbl btn"> </a></td>
						<td colspan="4">
							<input id="txtCustno" type="text" style="float:left;width:25%;"/>
							<input id="txtComp" type="text" style="float:left;width:75%;"/>
							<input id="txtNick" type="text" style="display:none;"/>
						</td>
						<td><span> </span><a id='lblContract' class="lbl"> </a></td>
						<td colspan="2"><input id="txtContract" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblTel' class="lbl"> </a></td>
						<td colspan='4'><input id="txtTel" type="text" class="txt c1"/></td>
						<td><span> </span><a class="lbl">報價號碼</a></td>
						<td colspan="2"><input id="txtQuatno" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblFax' class="lbl"> </a></td>
						<td colspan="4"><input id="txtFax" type="text" class="txt c1" /></td>
						<td><span> </span><a id="lblSales" class="lbl btn"> </a></td>
						<td colspan="2">
							<input id="txtSalesno" type="text" style="float:left;width:50%;"/>
							<input id="txtSales" type="text" style="float:left;width:50%;"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id='lblAddr' class="lbl"> </a></td>
						<td colspan="4">
							<input id="txtPost" type="text" style="float:left;width:25%;"/>
							<input id="txtAddr" type="text" style="float:left;width:75%;" />
						</td>
						<td><span> </span><a id='lblTrantype' class="lbl"> </a></td>
						<td colspan="2"><select id="cmbTrantype" class="txt c1" name="D1" > </select></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblAddr2' class="lbl"> </a></td>
						<td colspan="4">
							<input id="txtPost2" type="text" style="float:left;width:25%;"/>
							<input id="txtAddr2" type="text" style="float:left;width:75%;" />
						</td>
						<td><span> </span><a id='lblPaytype' class="lbl"> </a></td>
						<td colspan="2">
							<input id="txtPaytype" type="text" style="float:left; width:87%;"/>
							<select id="combPaytype" style="float:left; width:26px;"> </select>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id='lblMoney' class="lbl"> </a></td>
						<td><input id="txtMoney" type="text" class="txt num c1" /></td>
						<td><span> </span><a id='lblTax' class="lbl"> </a></td>
						<td><input id="txtTax" type="text" class="txt num c1" /></td>
						<td>
							<span style="float:left;display:block;width:10px;"> </span>
							<select id="cmbTaxtype" style="float:left;width:80px;" > </select>
						</td>
						<td><span> </span><a id='lblTotal' class="lbl"> </a></td>
						<td><input id="txtTotal" type="text" class="txt num c1" /></td>
						<td align="center"><input id="btnCredit" type="button" value='' /></td>
					</tr>
					<tr style="display: none;">
						<td><span> </span><a id='lblTotalus' class="lbl"> </a></td>
						<td><input id="txtTotalus" type="text" class="txt num c1" /></td>
						<td><span> </span><a id='lblFloata' class="lbl"> </a></td>
						<td><input id="txtFloata" type="text" class="txt num c1" /></td>
						<td>
							<span style="float:left;display:block;width:10px;"> </span>
							<select id="cmbCoin" style="float:left;width:80px;" onchange='coin_chg()'> </select>
						</td>
						<td><span> </span><a id='lblWeight' class="lbl"> </a></td>
						<td><input id="txtWeight" type="text" class="txt num c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblMemo' class="lbl"> </a></td>
						<td colspan="7"><input id="txtMemo" type="text" class="txt c1" /></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblWorker' class="lbl"> </a></td>
						<td><input id="txtWorker" type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblWorker2' class="lbl"> </a></td>
						<td><input id="txtWorker2" type="text" class="txt c1"/></td>
						<td> </td>
						<td> </td>
						<td align="center">
							<input id="chkIsproj" type="checkbox"/>
							<span> </span><a id='lblIsproj'> </a>
						</td>
						<td align="center">
							<input id="chkEnda" type="checkbox"/>
							<span> </span><a id='lblEnd'> </a>
						</td>
						<!--<td><input id="btnApv" type="button" style="width:70%;float:right;" value="核准"/></td>
						<td><input id="txtApv" type="text" class="txt c1" disabled="disabled"/></td>-->
					</tr>
				</table>
			</div>
		</div>
		<div class='dbbs'>
			<table id="tbbs" class='tbbs' style=' text-align:center'>
				<tr style='color:white; background:#003366;' >
					<td align="center" style="width:30px;">
						<input class="btn" id="btnPlus" type="button" value='+' style="font-weight: bold;" />
					</td>
					<td align="center" style="width:20px;"> </td>
					<td align="center" style="width:60px;"><a id='lblNo2'> </a></td>
					<td align="center" style="width:170px;"><a id='lblProductno'> </a></td>
					<td align="center" style="width:300px;"><a id='lblProduct_s'> </a>/規格</td>
					<td align="center" style="width:40px;">型</td>
					<!--<td align="center" style="width:120px;"><a id='lblWeights'> </a></td>-->
					<td align="center" style="width:100px;"><a id='lblMount'> </a></td>
					<td align="center" style="width:100px;"><a>計價數量</a></td>
					<td align="center" style="width:50px;"><a id='lblUnit'> </a></td>
					<td align="center" style="width:100px;"><a id='lblPrices'> </a></td>
					<td align="center" style="width:100px;"><a id='lblTotals'> </a><!--<br><a id='lblTheorys'> </a>--></td>
					<td align="center" style="width:100px;"><a id='lblGemounts'> </a><br><a id='lblNotv'> </a></td>
					<td align="center" style="width:100px;"><a id='lblDateas'> </a></td>
					<td align="center" style="width:250px;"><a id='lblMemo_s'> </a></td>
					<td align="center" style="width:40px;"><a id='lblChoice_s'> </a></td>
					<td align="center" style="width:40px;"><a id='lblSlit_tn'> </a></td>
					<td align="center" style="width:40px;"><a id='lblIscut_tn'> </a></td>
					<td align="center" style="width:40px;"><a id='lblEnda_st'> </a></td>
					<td align="center" style="width:40px;"><a id='lblBorn'> </a></td>
				</tr>
				<tr style='background:#cad3ff;'>
					<td align="center">
						<input class="btn" id="btnMinus.*" type="button" value='-' style=" font-weight: bold;" />
					</td>
					<td><a id="lblNo.*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
					<td><input class="txt" id="txtNo2.*" type="text" style="width:95%;"/></td>
					<td>
						<input class="btn" id="btnProduct.*" type="button" value='.' style=" font-weight: bold;width:15px;float:left;" />
						<input type="text" id="txtProductno.*" style="width:145px; float:left;"/>
					</td>
					<td>
						<span style="width:20px;height:1px;display:none;float:left;"> </span>
						<input id="txtProduct.*" type="text" style="float:left;width:93%;"/>
						<input id="txtSpec.*" type="text" style="float:left;width:93%;"/>
						<input class="btn" id="btnUno.*" type="button" value='' style="display:none;float:left;width:20px;height:25px;"/>
						<input id="txtUno.*" type="text" style="display:none;float:left;width:100px;" />
					</td>
					<td>
						<input id="txtStyle.*" type="text" class="txt" style="width:95%;text-align: center;"/>
						<div id="tn_style.*" class="tn_style" style="position: absolute;display: none;border:1px solid #000;">
							<div style="width:150px;display:block;float:left;background-color:#CDFFCE;">
								<div style="height: 30px;">長<span> </span><input id="textLengthb.*" type="text" class="txt num" style="width:60%;float: right;"/></div>
								<div style="height: 30px;">寬<span> </span><input id="textWidth.*" type="text" class="txt num" style="width:60%;float: right;"/></div>
								<div style="height: 30px;">片<span> </span><input id="textLengthc.*" type="text" class="txt num" style="width:60%;float: right;"/></div>
								<div class="tn_dime" style="height: 30px;">厚<span> </span><input id="textDime.*" type="text" class="txt num tn_dime" style="width:60%;float: right;"/></div>
							</div>
							<div style="width:10px;display:block;float:left;background-color:#CDFFCE;">
							</div>
							<div class="tn_dime" style="width:150px;display:block;float:left;background-color:#CDFFCE;">
								<div style="height: 30px;">長<span> </span><input id="textLength1.*" type="text" class="txt num tn_dime" style="width:60%;float: right;"/></div>
								<div style="height: 30px;"><input id="textLength2.*" type="text" class="txt num tn_dime" style="width:60%;float: right;"/></div>
								<div style="height: 30px;">短<span> </span><input id="textShort1.*" type="text" class="txt num tn_dime" style="width:60%;float: right;"/></div>
								<div style="height: 30px;"><input id="textShort2.*" type="text" class="txt num tn_dime" style="width:60%;float: right;"/></div>
							</div>
							<div style="display:block;background-color:#CDFFCE;">
								<input type="button" value="確定" id="btnStyleok.*">
							</div>
						</div>
						<input id="txtLengthb.*" type="hidden" class="txt" style="width:95%;"/>
						<input id="txtWidth.*" type="hidden" class="txt" style="width:95%;"/>
						<input id="txtLengthc.*" type="hidden" class="txt" style="width:95%;"/>
						<input id="txtDime.*" type="hidden" class="txt" style="width:95%;"/>
						<input id="txtClass.*" type="hidden" class="txt" style="width:95%;"/>
					</td>
					<!--<td><input id="txtWeight.*" type="text" class="txt num" style="width:95%;"/></td>-->
					<td><input id="txtMount.*" type="text" class="txt num" style="width:95%;"/></td>
					<td><input id="txtRadius.*" type="text" class="txt num" style="width:95%;"/></td>
					<td><input id="txtUnit.*" type="text" style="width:90%;text-align: center;"/></td>
					<td><input id="txtPrice.*" type="text" class="txt num" style="width:95%;"/></td>
					<td>
						<input id="txtTotal.*" type="text" class="txt num" style="width:95%;"/>
						<input id="txtTheory.*" type="hidden" class="txt num" style="width:95%;"/>
					</td>
					<td>
						<input class="txt num " id="txtC1.*" type="text" style="width:95%;"/>
						<input class="txt num " id="txtNotv.*" type="text" style="width:95%;"/>
					</td>
					<td><input class="txt " id="txtDatea.*" type="text" style="width:95%;"/></td>
					<td>
						<input id="txtMemo.*" type="text" style="width:95%; float:left;"/>
						<!--<input id="txtQuatno.*" type="text" style="width:70%;float:left;"/>
						<input id="txtNo3.*" type="text" style="width:20%;float:left;"/>-->
					</td>
					<td>
						<input class="txt" id="txtSizea.*" type="text" style="width:95%;display:none;"/>
						<input id="btnChoice.*" type="button" style="text-weight:bold;" value="+"/>
						<div id="Choice.*" style="position: absolute;display:none;">
							<div id="ChoiceOkDiv.*" style="text-align:center;float:left;border:1px solid #000;border-bottom:none;background-color:#CDFFCE;">
								<input type="button" value="確定" id="btnChoiceok.*">
								<input type="button" value="關閉" id="btnChoiceclose.*">
							</div>
							<div id="ChoiceBase1.*" style="width:450px;border:1px solid #000;float:left">
								<div style="float:left;background-color:#F8D463;">
									<div style="width:149px;display:block;float:left;">工廠</div>
									<div style="border-left:1px solid #000;width:300px;display:block;float:left;">加工方式</div>
								</div>
								<div style="float:left;border-top:1px solid #000;background-color:#CDFFCE;">
									<div style="width:149px;display:block;float:left;">
										<input type="button" value="." style="width:15%;float:left;text-weight:bold;" id="btnCno.*">
										<input type="text" class="txt c1" style="width:80%;" id="textCno.*">
										<input type="text" class="txt c1" style="width:95%;" id="textComp.*">
									</div>
									<div style="border-left:1px solid #000;width:300px;display:block;float:left;" id="checkXmemo.*"> </div>
								</div>
								<div style="float:left;border-top:1px solid #000;background-color:#CDFFCE;">
									<div style="width:149px;display:block;float:left;">
										<input type="button" value="." style="width:15%;float:left;text-weight:bold;" id="btnCno2.*">
										<input type="text" class="txt c1" style="width:80%;" id="textCno2.*">
										<input type="text" class="txt c1" style="width:95%;" id="textComp2.*">
									</div>
									<div style="border-left:1px solid #000;width:300px;display:block;float:left;" id="checkXmemo2.*"> </div>
								</div>
							</div>
							<div id="choicehr.*" style="float:left;width:35px;border-top:1px solid #000;border-bottom:1px solid #000;background-color:#CDFFCE;">
								委<br>外<br>廠<br>商<br>→
							</div>
							<div id="ChoiceBase2.*" style="width:450px;border:1px solid #000;float:left;">
								<div style="float:left;background-color:#F8D463;">
									<div style="width:149px;display:block;float:left;">委外工廠</div>
									<div style="border-left:1px solid #000;width:300px;display:block;float:left;">委外加工方式</div>
								</div>
								<div style="float:left;border-top:1px solid #000;background-color:#CDFFCE;">
									<div style="width:149px;display:block;float:left;">
										<input type="button" value="." style="width:15%;float:left;text-weight:bold;" id="btnOutcno.*">
										<input type="text" class="txt c1" style="width:80%;" id="textOutcno.*">
										<input type="text" class="txt c1" style="width:95%;" id="textOutcomp.*">
									</div>
									<div style="border-left:1px solid #000;width:300px;display:block;float:left;" id="checkOutxmemo.*"> </div>
								</div>
								<div style="float:left;border-top:1px solid #000;background-color:#CDFFCE;">
									<div style="width:149px;display:block;float:left;">
										<input type="button" value="." style="width:15%;float:left;text-weight:bold;" id="btnOutcno2.*">
										<input type="text" class="txt c1" style="width:80%;" id="textOutcno2.*">
										<input type="text" class="txt c1" style="width:95%;" id="textOutcomp2.*">
									</div>
									<div style="border-left:1px solid #000;width:300px;display:block;float:left;" id="checkOutxmemo2.*"> </div>
								</div>
							</div>
						</div>
					</td>
					<td align="center"><input id="chkSlit.*" type="checkbox"/></td>
					<td align="center"><input id="chkCut.*" type="checkbox"/></td>
					<td align="center"><input id="chkEnda.*" type="checkbox"/></td>
					<td align="center">
						<input class="btn" id="btnBorn.*" type="button" value='.' style=" font-weight: bold;" />
					</td>
				</tr>
			</table>
		</div>
		<input id="q_sys" type="hidden" />
	</body>
</html>