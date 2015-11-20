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
			var q_name = "vcc";
			var q_readonly = ['txtVccatax', 'txtComp', 'txtAccno', 'txtAcomp', 'txtSales', 'txtNoa', 'txtWorker', 'txtWorker2', 'txtMoney', 'txtTotal', 'txtTax'];
			var q_readonlys = ['txtTotal', 'txtOrdeno', 'txtNo2', 'txtTheory','txtStore'];
			
			var bbmNum = [
				['txtPrice', 15, 3, 1], ['txtVccatax', 10, 0, 1], ['txtMoney', 10, 0, 1],
				['txtTranmoney', 10, 0, 1], ['txtTax', 10, 0, 1], ['txtTotal', 10, 0, 1],
				['txtTotalus', 10, 2, 1], ['txtWeight', 10, 3, 1], ['txtFloata', 10, 4, 1]
			];
			var bbsNum = [
				['txtPrice', 15, 1, 1], ['txtTotal', 15, 0, 1], ['txtWeight', 10, 3, 1],
				['txtMount', 10, 2, 1],['txtRadius', 10, 2, 1], ['txtTheory', 12, 3, 1], ['txtGweight', 10, 3, 1],
				['txtWidth', 10, 0, 1], ['txtLengthc', 10, 0, 1], ['txtLengthb', 10, 0, 1], ['txtDime', 10, 0, 1]
			];
			var bbmMask = [];
			var bbsMask = [['txtStyle', 'A']];
			q_sqlCount = 6;
			brwCount = 6;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'noa';
			//ajaxPath = "";
			aPop = new Array(
				['txtCustno', 'lblCust', 'cust', 'noa,comp,nick,tel,zip_comp,addr_comp,paytype', 'txtCustno,txtComp,txtNick,txtTel,txtPost,txtAddr,txtPaytype', 'cust_b.aspx'],
				['txtSalesno', 'lblSales', 'sss', 'noa,namea', 'txtSalesno,txtSales', 'sss_b.aspx'],
				['txtCno', 'lblAcomp', 'acomp', 'noa,nick,addr', 'txtCno,txtAcomp,txtAddr2,txtInvono', 'acomp_b.aspx'],
				['txtAddr', '', 'view_road', 'memo,zipcode', '0txtAddr,txtPost', 'road_b.aspx'],
				['txtProductno_', 'btnProductno_', 'ucc', 'noa,product,spec,unit,saleprice', '0txtProductno_,txtProduct_,txtSpec_,txtUnit_,txtPrice_,txtStyle_', 'ucc_b.aspx'],
				//['txtUno_', 'btnUno_', 'view_uccc2', 'uno,uno,productno,class,spec,style,product,emount,eweight', '0txtUno_,txtUno_,txtProductno_,txtClass_,txtSpec_,txtStyle_,txtProduct_,txtMount_,txtWeight_', 'uccc_seek_b2.aspx?;;;1=0', '95%', '60%'],
				['txtStoreno_', 'btnStoreno_', 'store', 'noa,store', 'txtStoreno_,txtStore_,txtMemo_', 'store_b.aspx'],
				['txtCardealno', 'lblCardeal', 'cardeal', 'noa,comp', 'txtCardealno,txtCardeal', 'cardeal_b.aspx']
			);
			brwCount2 = 10;
			var isinvosystem = false;
			//購買發票系統
			$(document).ready(function() {
				bbmKey = ['noa'];
				bbsKey = ['noa', 'noq'];
				q_brwCount();
				//判斷是否有買發票系統
				q_gt('ucca', 'stop=1 ', 0, 0, 0, "ucca_invo");
				q_gt('flors_coin', '', 0, 0, 0, "flors_coin");
			});
			function main() {
				if (dataErr) {
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
				var t_tranmoney = dec($('#txtTranmoney').val());
				for (var j = 0; j < q_bbsCount; j++) {
					t_prices = q_float('txtPrice_' + j);
					//t_mount = q_float('txtMount_' + j);
					t_mount = q_float('txtRadius_' + j)>0?q_float('txtRadius_' + j):q_float('txtMount_' + j);
					t_moneys = round(q_mul(t_prices, t_mount), 0);
					t_money = q_add(t_money, t_moneys);
					$('#txtTotal_' + j).val(FormatNumber(t_moneys));
				}
				/*t_money = q_add(t_money,t_tranmoney);*/
				t_total = t_money;
				t_tax = 0;
				t_taxrate = parseFloat(q_getPara('sys.taxrate')) / 100;
				if (!isinvosystem) {
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
				}
				t_price = q_float('txtPrice');
				t_weight = q_float('txtWeight');
				if (t_price != 0) {
					$('#txtTranmoney').val(FormatNumber(round(q_mul(t_weight, t_price), 0)));
				}
				$('#txtMoney').val(FormatNumber(t_money));
				$('#txtTax').val(FormatNumber(t_tax));
				$('#txtTotal').val(FormatNumber(t_total));
			}

			function mainPost() {// 載入資料完，未 refresh 前
				if(r_rank<8){
					q_readonlys = ['txtTotal', 'txtOrdeno', 'txtNo2', 'txtTheory','txtStore','txtPrice'];
				}
				q_getFormat();
				bbmMask = [['txtDatea', r_picd], ['txtMon', r_picm]];
				q_mask(bbmMask);
				q_cmbParse("cmbTypea", q_getPara('vcc.typea'));
				q_cmbParse("cmbStype", q_getPara('vccst.stype'));
				//q_cmbParse("cmbCoin", q_getPara('sys.coin'));
				q_cmbParse("combPaytype", q_getPara('rc2.paytype'));
				q_cmbParse("cmbTrantype", q_getPara('sys.tran'));
				q_cmbParse("cmbTaxtype", q_getPara('sys.taxtype'));
				q_gt('spec', '', 0, 0, 0, "", r_accy);
				var t_where = "where=^^ 1=1 ^^";
				q_gt('custaddr', t_where, 0, 0, 0, "");
				//=======================================================
				//限制帳款月份的輸入 只有在備註的第一個字為*才能手動輸入
				$('#txtMemo').change(function() {
					if ($('#txtMemo').val().substr(0, 1) == '*')
						$('#txtMon').removeAttr('readonly');
					else
						$('#txtMon').attr('readonly', 'readonly');
				});
				
				$('#txtMon').click(function() {
					if ($('#txtMon').attr("readonly") == "readonly" && (q_cur == 1 || q_cur == 2))
						q_msg($('#txtMon'), "月份要另外設定，請在" + q_getMsg('lblMemo') + "的第一個字打'*'字");
				});

				$("#cmbTypea").focus(function() {
					var len = $(this).children().length > 0 ? $(this).children().length : 1;
					$(this).attr('size', len + "");
				}).blur(function() {
					$(this).attr('size', '1');
				});
				
				$("#cmbTaxtype").change(function(e) {
					sum();
				});
				
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
				//=====================================================================
				/* 若非本會計年度則無法存檔 */
				$('#txtDatea').focusout(function() {
					if ($(this).val().substr(0, 3) != r_accy) {
						$('#btnOk').attr('disabled', 'disabled');
						alert(q_getMsg('lblDatea') + '非本會計年度。');
					} else {
						$('#btnOk').removeAttr('disabled');
					}
				});
				
				$('#btnOrdeno').click(function() {
					if (!(q_cur == 1 || q_cur == 2))
						return;
					btnOrdes();
				});
				
				$('#lblAccno').click(function() {
					q_pop('txtAccno', "accc.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";accc3='" + $('#txtAccno').val() + "';" + $('#txtDatea').val().substring(0, 3) + '_' + r_cno, 'accc', 'accc3', 'accc2', "92%", "1054px", q_getMsg('btnAccc'), true);
				});
				
				$('#txtFloata').change(function() {
					sum();
				});
				
				$('#txtTax').change(function() {
					sum();
				});
				
				$('#txtPrice').change(function() {
					sum();
				});
				
				$('#txtTranmoney').change(function() {
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
				
				$('#txtCustno').change(function() {
					if (!emp($('#txtCustno').val())) {
						var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
						q_gt('custaddr', t_where, 0, 0, 0, "");
					}
				});
				
				$('#lblInvono').click(function() {
					if ($('#txtInvono').val().length > 0 && isinvosystem)
						q_pop('txtInvono', "vcca.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";noa='" + $('#txtInvono').val() + "';" + r_accy, 'vcca', 'noa', 'datea', "95%", "95%px", q_getMsg('lblInvono'), true);
				});

				if (isinvosystem) {
					$('.istax').hide();
					$('#txtVccatax').show();
				}
			}

			function q_boxClose(s2) {/// q_boxClose 2/4
				var ret;
				switch (s2[0]) {
					case 'ucc':
					 	var as=getb_ret();
					 	$('#txtProductno_'+pbtn_bseq).val(as[0].noa);
					 	pbtn_bseq='';
					break;
				}/// end Switch
				switch (b_pop) {
					case 'ordes':
						if (q_cur > 0 && q_cur < 4) {// q_cur： 0 = 瀏覽狀態 1=新增 2=修改 3=刪除 4=查詢
							b_ret = getb_ret();
							/// q_box() 執行後，選取的資料
							if (!b_ret || b_ret.length == 0) {
								b_pop = '';
								return;
							}
							
							for (var i = 0; i < q_bbsCount; i++) {
								$('#btnMinus_' + i).click();
							}
							
							var t_where = "where=^^ noa='" + b_ret[0].noa + "'";
							q_gt('view_orde', t_where, 0, 0, 0, "", r_accy);
							
							AddRet = q_gridAddRow(bbsHtm
							, 'tbbs', 'txtProductno,txtProduct,txtUnit,txtOrdeno,txtNo2,txtMount,txtPrice,txtSpec,txtStyle,txtLengthb,txtWidth,txtLengthc,txtDime,txtClass'
							, b_ret.length, b_ret
							, 'productno,product,unit,noa,no2,mount,price,spec,style,lengthb,width,lengthc,dime,class', 'txtProductno');
							
							/// 最後 aEmpField 不可以有【數字欄位】
							for (var i = 0; i < AddRet.length; i++) {
								$('#txtMount_' + i).change();
							}
							sum();
						}
						break;
					case q_name + '_s':
						q_boxClose2(s2);
						/// q_boxClose 3/4
						break;
				}/// end Switch
				b_pop = '';
			}

			function distinct(arr1) {
				var uniArray = [];
				for (var i = 0; i < arr1.length; i++) {
					var val = arr1[i];
					if ($.inArray(val, uniArray) === -1) {
						uniArray.push(val);
					}
				}
				return uniArray;
			}

			var focus_addr = '';
			var vcces_as = new Array;
			var t_uccArray = new Array;
			var AddRet = new Array;
			function q_gtPost(t_name) {/// 資料下載後 ...
				switch (t_name) {
					case 'btnDele':
						var as = _q_appendData("umms", "", true);
						if (as[0] != undefined) {
							var z_msg = "", t_paysale = 0;
							for (var i = 0; i < as.length; i++) {
								t_paysale = parseFloat(as[i].paysale.length == 0 ? "0" : as[i].paysale);
								if (t_paysale != 0)
									z_msg += String.fromCharCode(13) + '收款單號【' + as[i].noa + '】 ' + FormatNumber(t_paysale);
							}
							if (z_msg.length > 0) {
								alert('已沖帳:' + z_msg);
								Unlock(1);
								return;
							}
						}
						_btnDele();
						Unlock(1);
						break;
					case 'btnModi':
						var as = _q_appendData("umms", "", true);
						if (as[0] != undefined) {
							var z_msg = "", t_paysale = 0;
							for (var i = 0; i < as.length; i++) {
								t_paysale = parseFloat(as[i].paysale.length == 0 ? "0" : as[i].paysale);
								if (t_paysale != 0)
									z_msg += String.fromCharCode(13) + '收款單號【' + as[i].noa + '】 ' + FormatNumber(t_paysale);
							}
							if (z_msg.length > 0) {
								alert('已沖帳:' + z_msg);
								Unlock(1);
								return;
							}
						}
						_btnModi();
						Unlock(1);
						$('#txtDatea').focus();
						break;
					case 'ucca_invo':
						var as = _q_appendData("ucca", "", true);
						if (as[0] != undefined) {
							isinvosystem = true;
							$('.istax').hide();
						} else {
							isinvosystem = false;
						}
						q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
						break;
					case 'view_orde':
						var as = _q_appendData("view_orde", "", true);
						if (as[0] != undefined) {
							(trim($('#txtTel').val()) == '' ? $('#txtTel').val(as[0].tel) : '');
							(trim($('#txtFax').val()) == '' ? $('#txtFax').val(as[0].fax) : '');
							(trim($('#txtPost').val()) == '' ? $('#txtPost').val(as[0].post) : '');
							(trim($('#txtAddr').val()) == '' ? $('#txtAddr').val(as[0].addr) : '');
							(trim($('#txtPost2').val()) == '' ? $('#txtPost2').val(as[0].post2) : '');
							(trim($('#txtAddr2').val()) == '' ? $('#txtAddr2').val(as[0].addr2) : '');
							(trim($('#txtSalesno').val()) == '' ? $('#txtSalesno').val(as[0].salesno) : '');
							(trim($('#txtSales').val()) == '' ? $('#txtSales').val(as[0].sales) : '');
							(trim($('#txtPaytype').val()) == '' ? $('#txtPaytype').val(as[0].paytype) : '');
							$('#cmbTrantype').val(as[0].trantype);
							(trim($('#txtFloata').val()) == '' ? $('#txtFloata').val(as[0].floata) : '');
							$('#cmbCoin').val(as[0].coin);
						}
						break;
					case 'getAcomp':
						var as = _q_appendData("acomp", "", true);
						if (as[0] != undefined) {
							$('#txtCno').val(as[0].noa);
							$('#txtAcomp').val(as[0].nick);
						}
						Unlock(1);
						$('#txtNoa').val('AUTO');
						$('#txtDatea').val(q_date());
						//$('#txtMon').val(q_date().substring(0, 6));
						$('#cmbTypea').focus();
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
					case 'custaddr':
						var as = _q_appendData("custaddr", "", true);
						var t_item = " @ ";
						if (as[0] != undefined) {
							for ( i = 0; i < as.length; i++) {
								t_item = t_item + (t_item.length > 0 ? ',' : '') + as[i].post + '@' + as[i].addr;
							}
						}
						document.all.combAddr.options.length = 0;
						q_cmbParse("combAddr", t_item);
						break;
					case 'startdate':
						var as = _q_appendData('cust', '', true);
						var t_startdate = '';
						if (as[0] != undefined) {
							t_startdate = as[0].startdate;
						}
						if (t_startdate.length == 0 || ('00' + t_startdate).slice(-2) == '00' || $('#txtDatea').val().substr(7, 2) < ('00' + t_startdate).slice(-2)) {
							$('#txtMon').val($('#txtDatea').val().substr(0, 6));
						} else {
							var t_date = $('#txtDatea').val();
							var nextdate = new Date(dec(t_date.substr(0, 3)) + 1911, dec(t_date.substr(4, 2)) - 1, dec(t_date.substr(7, 2)));
							nextdate.setMonth(nextdate.getMonth() + 1)
							t_date = '' + (nextdate.getFullYear() - 1911) + '/' + (nextdate.getMonth() < 9 ? '0' : '') + (nextdate.getMonth() + 1);
							$('#txtMon').val(t_date);
						}
						check_startdate = true;
						btnOk();
						break;
					case q_name:
						t_uccArray = _q_appendData("ucc", "", true);
						if (q_cur == 4)// 查詢
							q_Seek_gtPost();
						break;
				} /// end switch
			}
			
			function coin_chg() {
				var t_where = "where=^^ ('" + $('#txtDatea').val() + "' between bdate and edate) and coin='"+$('#cmbCoin').find("option:selected").text()+"' ^^";
				q_gt('flors', t_where, 0, 0, 0, "");
			}

			function btnOrdes() {
				var t_custno = trim($('#txtCustno').val());
				var t_where = '';
				if (t_custno.length > 0) {
					t_where = "noa in (select noa from view_orde where isnull(enda,0)!='1') && " + (t_custno.length > 0 ? q_sqlPara("custno", t_custno) : "");
					if (!emp($('#txtOrdeno').val()))
						t_where += " && charindex(noa,'" + $('#txtOrdeno').val() + "')>0";
					t_where = t_where;
				} else {
					alert(q_getMsg('msgCustEmp'));
					return;
				}
				q_box("ordes_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'ordes', "95%", "650px", q_getMsg('popOrde'));
				
			}/// q_box() 開 視窗
			
			function GetOrdenoList() {
				var ReturnStr = new Array;
				for (var i = 0; i < q_bbsCount; i++) {
					var thisVal = trim($('#txtOrdeno_' + i).val());
					if (thisVal.length > 0)
						ReturnStr.push(thisVal);
				}
				ReturnStr = distinct(ReturnStr).sort();
				return ReturnStr.toString();
			}

			function GetUnoList() {
				var ReturnStr = new Array;
				for (var i = 0; i < q_bbsCount; i++) {
					var thisVal = trim($('#txtUno_' + i).val());
					if (thisVal.length > 0)
						ReturnStr.push(thisVal);
				}
				ReturnStr = distinct(ReturnStr).sort();
				return ReturnStr.toString();
			}

			var check_startdate = false;
			function btnOk() {
				var t_err = q_chkEmpField([['txtNoa', q_getMsg('lblNoa')], ['txtDatea', q_getMsg('lblDatea')], ['txtCustno', q_getMsg('lblCust')], ['txtCno', q_getMsg('lblAcomp')]]);
				if (t_err.length > 0) {
					alert(t_err);
					return;
				}

				Lock(1, {
					opacity : 0
				});

				$('#txtOrdeno').val(GetOrdenoList());

				if ($('#txtDatea').val().length == 0 || !q_cd($('#txtDatea').val())) {
					alert(q_getMsg('lblDatea') + '錯誤。');
					Unlock(1);
					return;
				}
				if ($('#txtDatea').val().substring(0, 3) != r_accy) {
					alert('年度異常錯誤，請切換到【' + $('#txtDatea').val().substring(0, 3) + '】年度再作業。');
					Unlock(1);
					return;
				}

				//判斷起算日,寫入帳款月份
				//104/09/30 如果備註沒有*字就重算帳款月份
				//if(!check_startdate && emp($('#txtMon').val())){
				if(!check_startdate && $('#txtMemo').val().substr(0,1)!='*'){	
					var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
					q_gt('cust', t_where, 0, 0, 0, "startdate", r_accy);
					return;
				}
				check_startdate = false;

				if ($.trim($('#txtNick').val()).length == 0 && $.trim($('#txtComp').val()).length > 0)
					$('#txtNick').val($.trim($('#txtComp').val()).substring(0, 4));
					
				if (q_cur == 1)
					$('#txtWorker').val(r_name);
				else
					$('#txtWorker2').val(r_name);
					
				sum();

				var s1 = $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val();
				if (s1.length == 0 || s1 == "AUTO")
					q_gtnoa(q_name, replaceAll(q_getPara('sys.key_vcc') + $('#txtDatea').val(), '/', ''));
				else
					wrServer(s1);
			}

			function q_stPost() {
				if (q_cur == 1 || q_cur == 2) {
					var s2 = xmlString.split(';');
					abbm[q_recno]['accno'] = s2[0];
				}
			}

			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)// 1-3
					return;

				q_box('vcc_tn_s.aspx', q_name + '_s', "500px", "530px", q_getMsg("popSeek"));
			}
			
			var pbtn_bseq='';
			function bbsAssign() {/// 表身運算式
				for (var j = 0; j < q_bbsCount; j++) {
					$('#lblNo_' + j).text(j + 1);
					if (!$('#btnMinus_' + j).hasClass('isAssign')) {
						
						$('#txtUnit_' + j).focusout(function() {
							if (q_cur == 1 || q_cur == 2)
								sum();
						});
						$('#txtRadius_' + j).focusout(function() {
							if (q_cur == 1 || q_cur == 2)
								sum();
						});
						$('#txtWeight_' + j).focusout(function() {
							if (q_cur == 1 || q_cur == 2)
								sum();
						});
						$('#txtPrice_' + j).focusout(function() {
							if (q_cur == 1 || q_cur == 2) {
								sum();
							}
						});
						$('#txtMount_' + j).focusout(function() {
							if (q_cur == 1 || q_cur == 2) {
								sum();
							}
						});
						$('#txtOrdeno_' + j).click(function() {
							var thisVal = $.trim($(this).val());
							if (thisVal.length > 0) {
								q_box("ordest.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";noa='" + thisVal + "';" + r_accy, 'ordest', "95%", "95%", q_getMsg("popOrdest"));
							}
						});
						$('#btnProductno_' + j).click(function() {
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length - 1];
							pbtn_bseq=n;
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
				}//j
				_bbsAssign();
			}

			function btnIns() {
				_btnIns();
				$('#cmbTaxtype').val(4);
				Lock(1, {
					opacity : 0
				});
				q_gt('acomp', '', 0, 0, 0, 'getAcomp', r_accy);
				var t_where = "where=^^ 1=1 ^^";
				q_gt('custaddr', t_where, 0, 0, 0, "");
			}

			function btnModi() {
				if (emp($('#txtNoa').val()))
					return;
				_btnModi();
				
				var t_where = " where=^^ vccno='" + $('#txtNoa').val() + "'^^";
				q_gt('umms', t_where, 0, 0, 0, 'btnModi', r_accy);
				
				$('#cmbTypea').focus();
				sum();
			}

			function btnPrint() {
				//q_box('z_vccstp.aspx', '', "95%", "95%", q_getMsg("popPrint"));
				q_box("z_vccp_tn.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";noa=" + $('#txtNoa').val() + ";" + r_accy, 'z_vccp_tn', "95%", "95%", q_getMsg('popPrint'));
			}

			function wrServer(key_value) {
				var i;
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
				_btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
				// key_value
			}

			function bbsSave(as) {
				if (!as['product'] && !as['uno'] && parseFloat(as['mount'].length == 0 ? "0" : as['mount']) == 0 ) {
					as[bbsKey[1]] = '';
					return;
				}

				q_nowf();
				as['type'] = abbm2['type'];
				as['mon'] = abbm2['mon'];
				as['noa'] = abbm2['noa'];
				as['datea'] = abbm2['datea'];
				as['tggno'] = abbm2['tggno'];
				as['kind'] = abbm2['kind'];
				if (abbm2['storeno'])
					as['storeno'] = abbm2['storeno'];

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
				//q_popPost('txtProductno_');
				$('input[id*="txtProduct_"]').each(function() {
					thisId = $(this).attr('id').split('_')[$(this).attr('id').split('_').length - 1];
					$(this).attr('OldValue', $('#txtProductno_' + thisId).val());
				});
				if (isinvosystem)
					$('.istax').hide();
			}

			var ret;
			//勿刪
			var x_bseq = 0;
			function q_popPost(s1) {
				switch (s1) {
					case 'txtCustno':
						if (!emp($('#txtCustno').val())) {
							var t_where = "where=^^ noa='" + $('#txtCustno').val() + "' ^^";
							q_gt('custaddr', t_where, 0, 0, 0, "");
						}
						break;
				}
			}

			function readonly(t_para, empty) {
				_readonly(t_para, empty);
				
				if (t_para) {
					$('#combAddr').attr('disabled', 'disabled');
				} else {
					$('#combAddr').removeAttr('disabled');
				}

				//限制帳款月份的輸入 只有在備註的第一個字為*才能手動輸入
				if ($('#txtMemo').val().substr(0, 1) == '*')
					$('#txtMon').removeAttr('readonly');
				else
					$('#txtMon').attr('readonly', 'readonly');
			}

			function btnMinus(id) {
				_btnMinus(id);
				sum();
			}

			function btnPlus(org_htm, dest_tag, afield) {
				_btnPlus(org_htm, dest_tag, afield);
				
				if (q_tables == 's')
					bbsAssign();
			}

			function q_appendData(t_Table) {
				dataErr = !_q_appendData(t_Table);
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
				if (q_chkClose())
					return;
				Lock(1, {
					opacity : 0
				});
				var t_where = " where=^^ vccno='" + $('#txtNoa').val() + "'^^";
				q_gt('umms', t_where, 0, 0, 0, 'btnDele', r_accy);
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
				//tipClose
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
				tip($('#btnOrdeno'), '<a style="color:darkblue;font-size:16px;font-weight:bold;width:300px;display:block;">點擊【' + q_getMsg('btnOrdeno') + '】匯入訂單</a>', 0, -15);
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

			function combAddr_chg() {/// 只有 comb 開頭，才需要寫 onChange() ，其餘 cmb 連結資料庫
				if (q_cur == 1 || q_cur == 2) {
					$('#txtAddr2').val($('#combAddr').find("option:selected").text());
					$('#txtPost2').val($('#combAddr').find("option:selected").val());
				}
			}
		</script>
		<style type="text/css">
			#dmain {
				overflow: hidden;
			}
			.dview {
				float: left;
				width: 350px;
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
				width: 900px;
				/*margin: -1px;
				 border: 1px black solid;*/
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
				/*width: 10%;*/
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
				width: 1550px;
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
	<!--#include file="../inc/toolbar.inc"-->
		<div id='dmain' style="overflow: auto;display:block;width:1280px;">
			<div class="dview" id="dview">
				<table class="tview" id="tview"	>
					<tr>
						<td align="center" style="width:20px; color:black;"><a id='vewChk'> </a></td>
						<td align="center" style="width:80px; color:black;"><a id='vewDatea'> </a></td>
						<td align="center" style="width:100px; color:black;"><a id='vewNoa'> </a></td>
						<td align="center" style="width:120px; color:black;"><a id='vewNick'> </a></td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox" style=''/></td>
						<td align="center" id='datea'>~datea</td>
						<td align="center" id='noa'>~noa</td>
						<td align="center" id='nick'>~nick</td>
					</tr>
				</table>
			</div>
			<div class="dbbm">
				<table class="tbbm" id="tbbm">
					<tr style="height:1px;">
						<td style="width: 107px;"> </td>
						<td style="width: 110px;"> </td>
						<td style="width: 110px;"> </td>
						<td style="width: 110px;"> </td>
						<td style="width: 110px;"> </td>
						<td style="width: 107px;"> </td>
						<td style="width: 107px;"> </td>
						<td style="width: 107px;"> </td>
						<td class="tdZ" style="width: 31px;"> </td>
					</tr>
					<tr>
						<td><span> </span><a id='lblType' class="lbl"> </a></td>
						<td>
							<select id="cmbTypea" class="txt" style="width:40%;"> </select>
							<select id="cmbStype" class="txt" style="width:60%;"> </select>
						</td>
						<td><span> </span><a id='lblDatea' class="lbl"> </a></td>
						<td colspan="2">
							<input id="txtDatea" type="text" class="txt c1" style="width:80px;"/>
							<span style="float: left;"> </span>
							<a id='lblMon' class="lbl" style="float: left;"> </a>
							<span style="float: left;"> </span>
							<input id="txtMon" type="text" class="txt c1" style="width:65px;"/>
						</td>				
						<td><span> </span><a id='lblNoa' class="lbl"> </a></td>
						<td colspan="2"><input id="txtNoa" type="text" class="txt c1"/></td>
						<td class="tdZ">
							<input type="button" id="btnTip" value="?" style="float:right;" onclick="tipShow()"/>
						</td>
					</tr>
					<!--<tr>
						<td colspan="2">
							<input type="checkbox" id="chkIsgenvcca" style="float:left;"/>
							<a id='lblIsgenvcca' class="lbl" style="float:left;"> </a>
						</td>
					</tr>-->
					<tr>
						<td><span> </span><a id='lblAcomp' class="lbl btn"> </a></td>
						<td colspan="4">
							<input id="txtCno" type="text" style="float:left;width:25%;"/>
							<input id="txtAcomp" type="text" style="float:left;width:75%;"/>
						</td>
						<td><span> </span><a id='lblInvono' class="lbl"> </a></td>
						<td colspan="2"><input id="txtInvono" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblCust" class="lbl btn"> </a></td>
						<td colspan="4">
							<input id="txtCustno" type="text" style="float:left;width:25%;"/>
							<input id="txtComp" type="text" style="float:left;width:75%;"/>
							<input id="txtNick" type="text" style="display:none;"/>
						</td>
						<td>
							<input id="btnOrdeno" type="button" class="lbl"/>
							<!--<span> </span><a id='lblOrdeno' class="lbl btn"> </a>-->
						</td>
						<td colspan="2"><input id="txtOrdeno" type="text" class="txt c1" /></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblTel' class="lbl"> </a></td>
						<td colspan="4"><input id="txtTel" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblSales" class="lbl btn"> </a></td>
						<td colspan="2">
							<input id="txtSalesno" type="text" style="float:left;width:50%;"/>
							<input id="txtSales" type="text" style="float:left;width:50%;"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id='lblAddr' class="lbl"> </a></td>
						<td colspan="4" >
							<input id="txtPost" type="text" style="float:left; width:70px;"/>
							<input id="txtAddr" type="text" style="float:left; width:369px;"/>
						</td>
						<td><span> </span><a id='lblTrantype' class="lbl"> </a></td>
						<td colspan="2"><select id="cmbTrantype" class="txt c1" name="D1" > </select></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblAddr2' class="lbl"> </a></td>
						<td colspan="4" >
							<input id="txtPost2" type="text" style="float:left; width:70px;"/>
							<input id="txtAddr2" type="text" style="float:left; width:352px;"/>
							<select id="combAddr" style="width: 20px" onchange='combAddr_chg()'> </select>
						</td>
						<td><span> </span><a id='lblPaytype' class="lbl"> </a></td>
						<td colspan="2">
							<input id="txtPaytype" type="text" style="float:left; width:195px;"/>
							<select id="combPaytype" style="float:left; width:20px;"> </select>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id='lblCardeal' class="lbl btn"> </a></td>
						<td colspan="4">
							<input id="txtCardealno" type="text" style="float:left;width:25%;"/>
							<input id="txtCardeal" type="text" style="float:left;width:75%;" />
						</td>
						<td><span> </span><a id='lblCarno' class="lbl"> </a></td>
						<td colspan="2"><input id="txtCarno" type="text" class="txt c1" style="float:left;" /></td>
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
						<td> </td>
						<td> </td>
						<td> </td>
					</tr>
					<tr>
						<td><span> </span><a id='lblMoney' class="lbl"> </a></td>
						<td><input id="txtMoney" type="text" class="txt num c1" /></td>
						<td><span> </span><a id='lblTax' class="lbl"> </a></td>
						<td>
							<input id="txtTax" type="text" class="txt num c1 istax" />
							<input id="txtVccatax" type="text" class="txt num c1 " style="display:none;" />
						</td>
						<td>
							<span style="float:left;display:block;width:10px;"> </span>
							<select id="cmbTaxtype" style="float:left;width:80px;" > </select>
						</td>
						<td><span> </span><a id='lblTotal' class="lbl istax"> </a></td>
						<td colspan="2"><input id="txtTotal" type="text" class="txt num c1 istax" /></td>
					</tr>
					<tr style="display: none;">
						<td><span> </span><a id='lblWeight' class="lbl"> </a></td>
						<td><input id="txtWeight" type="text" class="txt num c1" /></td>
						<td><span> </span><a id='lblPrices' class="lbl"> </a></td>
						<td><input id="txtPrice" type="text" class="txt num c1" /></td>
						<td>	</td>
						<td><span> </span><a id='lblTranmoney' class="lbl"> </a></td>
						<td><input id="txtTranmoney" type="text" class="txt num c1" /></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblMemo' class="lbl"> </a></td>
						<td colspan="7"><input id="txtMemo" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblWorker' class="lbl"> </a></td>
						<td><input id="txtWorker" type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblWorker2' class="lbl"> </a></td>
						<td><input id="txtWorker2" type="text" class="txt c1"/></td>
						<td> </td>
						<!--<td><span> </span><a id="lblAccno" class="lbl btn"> </a></td>
						<td><input id="txtAccno" type="text" class="txt c1"/></td>-->
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
					<td align="center" style="display: none;"><a id="lblUno_st" > </a></td>
					<td align="center" style="width:150px;"><a id='lblProductno_s'> </a></td>
					<td align="center" style="width:300px;"><a id='lblProduct_s'> </a>/<a id='lblSpec_s'> </a></td>
					<!--<td align="center" style="width:180px;"><a id='lblSizea_st'></a></td>-->
					<td align="center" style="width:40px;">型</td>					
					<!--<td align="center" style="width:100px;"><a id='lblWeight_st'></a></td>-->
					<td align="center" style="width:80px;"><a id='lblMount_st'> </a></td>
					<td align="center" style="width:80px;"><a>計價數量</a></td>
					<td align="center" style="width:40px;"><a id='lblUnit'> </a> </td>
					<td align="center" style="width:80px;"><a id='lblPrices_st'> </a></td>
					<td align="center" style="width:100px;"><a id='lblTotal_s'> </a></td>
					<!--<td align="center" style="width:100px;"><a id='lblGweight_st'></a></td>-->
					<td align="center" style="width:120px;"><a id='lblStore_s'> </a></td>
					<td align="center" style="width:180px;"><a id='lblMemos_st'> </a></td>
				</tr>
				<tr style='background:#cad3ff;'>
					<td align="center">
						<input class="btn" id="btnMinus.*" type="button" value='-' style=" font-weight: bold;" />
						<input id="txtNoq.*" type="text" style="display: none;" />
					</td>
					<td><a id="lblNo.*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
					<td style="display: none;">
						<input class="btn" id="btnUno.*" type="button" value='.' style="width:10%;"/>
						<input id="txtUno.*" type="hidden" style="width:80%;"/>
					</td>
					<td>
						<input class="btn" id="btnProductno.*" type="button" value='.' style=" font-weight: bold;width:15px;float:left;" />
						<input id="txtProductno.*" type="text" class="txt c1" style="width:85%;"/>
						<!--<input id="txtClass.*" type="text" style='width: 85px;'/>-->
					</td>
					<td>
						<input class="txt c1" id="txtProduct.*" type="text" />
						<input class="txt c1" id="txtSpec.*" type="text"/>
					</td>
					<!--<td><input id="txtSize.*" type="text" style="width:95%;" /></td>-->
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
					<td>	<input id="txtMount.*" type="text" class="txt num" style="width:95%;"/></td>
					<td><input id="txtRadius.*" type="text" class="txt num" style="width:95%;"/></td>
					<td><input id="txtUnit.*" type="text" class="txt" style="width:95%;text-align: center;"/></td>
					<td><input id="txtPrice.*" type="text" class="txt num" style="width:95%;"/></td>
					<td>
						<input id="txtTotal.*" type="text" class="txt num" style="width:95%;"/>
						<input id="txtTheory.*" type="hidden" class="txt num" style="width:95%;"/>
					</td>
					<!--<td><input id="txtGweight.*" type="text" class="txt num" style="width:95%;"/></td>-->
					<td>
						<input id="txtStoreno.*" type="text" class="txt c1" style="width: 75%"/>
						<input class="btn"  id="btnStoreno.*" type="button" value='.' style=" font-weight: bold;" />
						<input id="txtStore.*" type="text" class="txt c1"/>
					</td>
					<td>
						<input id="txtMemo.*" type="text" class="txt" style="width:95%;"/>
						<input id="txtOrdeno.*" type="text" style="width:65%;" />
						<input id="txtNo2.*" type="text" style="width:20%;" />
						<input id="recno.*" type="hidden" />
					</td>
				</tr>
			</table>
		</div>
		<input id="q_sys" type="hidden" />
	</body>
</html>