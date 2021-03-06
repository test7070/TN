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
		<script type="text/javascript">
			this.errorHandler = null;
			function onPageError(error) {
				alert("An error occurred:\r\n" + error.Message);
			}
			q_desc = 1;
			q_tables = 's';
			var q_name = "ordc";
			var q_readonly = ['txtTgg', 'txtAcomp', 'txtSales', 'txtNoa', 'txtWorker', 'txtWorker2','txtMoney','txtTax','txtTotal'];
			var q_readonlys = ['txtNo2', 'txtC1', 'txtNotv','txtOmount','chkEnda','txtTotal'];
			var bbmNum = [
				['txtFloata', 10, 5, 1], ['txtMoney', 10, 0, 1], ['txtTax', 10, 0, 1],
				['txtTotal', 10, 0, 1], ['txtTotalus', 10, 0, 1]
			];
			var bbsNum = [['txtMount', 15, 2, 1],['txtPrice', 10, 1, 1],['txtTotal', 15, 0, 1],['txtOmount', 10, 2, 1],
									['txtLengthc', 10, 0, 1],['txtLengthb', 10, 0, 1],['txtDime', 10, 0, 1],['txtWidth', 10, 0, 1]];
			var bbmMask = [];
			var bbsMask = [];
			q_sqlCount = 6;
			brwCount = 6;
			brwCount2 = 13;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'Odate';
			aPop = new Array(
				['txtProductno1_', 'btnProduct1_', 'ucc', 'noa,product,spec,unit,saleprice', '0txtProductno1_,txtProduct_,txtSpec_,txtUnit_,txtPrice_,txtStyle_', 'ucc_b.aspx'],
				['txtProductno2_', 'btnProduct2_', 'bcc', 'noa,product,unit', 'txtProductno2_,txtProduct_,txtUnit_,txtMount_', 'bcc_b.aspx'],
				['txtProductno3_', 'btnProduct3_', 'fixucc', 'noa,namea,unit', 'txtProductno3_,txtProduct_,txtUnit_,txtMount_', 'fixucc_b.aspx'],
				['txtSalesno', 'lblSales', 'sss', 'noa,namea', 'txtSalesno,txtSales,txtPaytype', 'sss_b.aspx'],
				['txtCno', 'lblAcomp', 'acomp', 'noa,acomp,addr', 'txtCno,txtAcomp,txtAddr2,txtTggno', 'acomp_b.aspx'],
				['txtTggno', 'lblTgg', 'tgg', 'noa,comp,trantype,paytype,salesno,sales,tel,fax,zip_comp,addr_comp'
				, 'txtTggno,txtTgg,cmbTrantype,txtPaytype,txtSalesno,txtSales,txtTel,txtFax,txtPost,txtAddr,txtPost2', 'tgg_b.aspx']
			);
			$(document).ready(function() {
				bbmKey = ['noa'];
				bbsKey = ['noa', 'no2'];
				q_brwCount();
				q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
				q_gt('acomp', 'stop=1 ', 0, 0, 0, "cno_acomp");
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
				var t1 = 0, t_unit, t_mount, t_weight = 0;
				var t_money = 0;
				for (var j = 0; j < q_bbsCount; j++) {
					q_tr('txtTotal_' + j, q_mul(q_float('txtMount_' + j), q_float('txtPrice_' + j)));
					q_tr('txtNotv_' + j, q_sub(q_float('txtMount_' + j), q_float('txtC1' + j)));
					t_money = q_add(t_money, q_float('txtTotal_' + j));
				}
				q_tr('txtMoney', t_money);
				q_tr('txtTotal', q_add(q_float('txtMoney'), q_float('txtTax')));
				q_tr('txtTotalus', q_mul(q_float('txtTotal'), q_float('txtFloata')));

				calTax();
			}

			function mainPost() {
				q_getFormat();
				bbmMask = [['txtDatea', r_picd], ['txtOdate', r_picd], ['txtTrandate', r_picd], ['txtEtd', r_picd], ['txtEta', r_picd], ['txtOnboarddate', r_picd]];
				bbsMask = [['txtTrandate', r_picd],['txtStyle', 'A']];
				q_mask(bbmMask);
				q_cmbParse("cmbKind", q_getPara('ordc.kind'));
				//q_cmbParse("cmbCoin", q_getPara('sys.coin'));
				q_cmbParse("combPaytype", q_getPara('rc2.paytype'));
				q_cmbParse("cmbTrantype", q_getPara('sys.tran'));
				q_cmbParse("cmbTaxtype", q_getPara('sys.taxtype'));
				var t_where = "where=^^ 1=0 ^^ stop=100";
				q_gt('custaddr', t_where, 0, 0, 0, "");
				$('#cmbKind').change(function() {
					for (var j = 0; j < q_bbsCount; j++) {
						btnMinus('btnMinus_' + j);
					}
					product_change();
				});
				$('#lblOrdb').click(function() {
					var t_tggno = trim($('#txtTggno').val());
					var t_ordbno = trim($('#txtOrdbno').val());
					var t_where = '';
					if (t_tggno.length > 0) {
						if (t_ordbno.length > 0)
							t_where = "isnull(b.enda,'0')='0' and ( b.noa+'_'+b.no3 not in (select isnull(ordbno,'')+'_'+isnull(no3,'') from view_ordc" + r_accy + " where noa!='" + $('#txtNoa').val() + "' ) ) and " + q_sqlPara("a.tggno", t_tggno) + "and " + q_sqlPara("a.noa", t_ordbno) + " and a.kind='" + $('#cmbKind').val() + "'";
						else
							t_where = "isnull(b.enda,'0')='0' and ( b.noa+'_'+b.no3 not in (select isnull(ordbno,'')+'_'+isnull(no3,'') from view_ordc" + r_accy + " where noa!='" + $('#txtNoa').val() + "' ) ) and " + q_sqlPara("a.tggno", t_tggno) + " and a.kind='" + $('#cmbKind').val() + "'";
						t_where = t_where;
					} else {
						alert('請輸入' + q_getMsg('lblTgg'));
						return;
					}
					q_box("ordbs_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'ordbs', "95%", "95%", q_getMsg('popOrdbs'));
				});
				$('#txtFloata').change(function() {
					sum();
				});
				$('#txtTotal').change(function() {
					sum();
				});
				$('#txtTggno').change(function() {
					if (!emp($('#txtTggno').val())) {
						var t_where = "where=^^ noa='" + $('#txtTggno').val() + "' ^^ stop=100";
						q_gt('custaddr', t_where, 0, 0, 0, "");
					}
				});
				$('#txtAddr').change(function() {
					var t_tggno = trim($(this).val());
					if (!emp(t_tggno)) {
						focus_addr = $(this).attr('id');
						zip_fact = $('#txtPost').attr('id');
						var t_where = "where=^^ noa='" + t_tggno + "' ^^";
						q_gt('tgg', t_where, 0, 0, 0, "");
					}
				});
				$('#txtAddr2').change(function() {
					var t_custno = trim($(this).val());
					if (!emp(t_custno)) {
						focus_addr = $(this).attr('id');
						zip_fact = $('#txtPost2').attr('id');
						var t_where = "where=^^ noa='" + t_custno + "' ^^";
						q_gt('cust', t_where, 0, 0, 0, "");
					}
				});
				$('#btnImport').click(function() {
					if ($('#btnImport').val() == '進口欄位顯示') {
						$('.import').show();
						$('#btnImport').val('進口欄位隱藏');
					} else {
						$('.import').hide();
						$('#btnImport').val('進口欄位顯示');
					}
				});
				$('#txtOdate').focusout(function(){
					var thisVal = $.trim($(this).val());
					if(checkId(thisVal) != 0){
						$('#txtDatea').val(q_cdn(thisVal,20));
					}
				});
				$('#chkCancel').click(function(){
					if($(this).prop('checked')){
						for(var k=0;k<q_bbsCount;k++){
							$('#chkCancel_'+k).prop('checked',true);
						}
					}
				});
			}

			function q_boxClose(s2) {
				var ret;
				switch (s2[0]) {
					case 'ucc':
					 	var as=getb_ret();
					 	if ($('#cmbKind').val() == '1') {
					 		$('#txtProductno1_'+pbtn_bseq).val(as[0].noa);
					 	}else if ($('#cmbKind').val() == '2') {
					 		$('#txtProductno2_'+pbtn_bseq).val(as[0].noa);
					 	}else if ($('#cmbKind').val() == '3') {
					 		$('#txtProductno3_'+pbtn_bseq).val(as[0].noa);
					 	}
					 	pbtn_bseq='';
					break;
				}/// end Switch
				switch (b_pop) {
					case 'ordbs':
						if (q_cur > 0 && q_cur < 4) {
							b_ret = getb_ret();
							if (!b_ret || b_ret.length == 0)
								return;
							//取得請購的資料
							var t_where = "where=^^ noa='" + b_ret[0].noa + "' ^^";
							q_gt('ordb', t_where, 0, 0, 0, "", r_accy);
							$('#txtOrdbno').val(b_ret[0].noa);
							ret = q_gridAddRow(bbsHtm, 'tbbs', 'txtProductno,txtProduct,txtOrdbno,txtNo3,txtPrice,txtMount,txtTotal,txtMemo,txtUnit,txtSpec', b_ret.length, b_ret, 'productno,product,noa,no3,price,mount,total,memo,unit,txtSpec', 'txtProductno,txtProduct');
							bbsAssign();
						}
						break;
					case q_name + '_s':
						q_boxClose2(s2);
						break;
				}
				b_pop = '';
			}

			var focus_addr = '', zip_fact = '';
			var z_cno = r_cno, z_acomp = r_comp, z_nick = r_comp.substr(0, 2), z_addr2 = '';
			function q_gtPost(t_name) {
				switch (t_name) {
					case 'GetOrdct':
						var as = _q_appendData("ordct", "", true);
						if(as.length > 0){
							alert('禁止修改');
						}else{
							ModiDo();
						}
						break;
					case 'cno_acomp':
						var as = _q_appendData("acomp", "", true);
						if (as[0] != undefined) {
							z_cno = as[0].noa;
							z_acomp = as[0].acomp;
							z_nick = as[0].nick;
							z_addr2=as[0].addr;
						}
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
					case 'tgg':
						var as = _q_appendData("tgg", "", true);
						if (as[0] != undefined && focus_addr != '') {
							$('#' + zip_fact).val(as[0].zip_fact);
							$('#' + focus_addr).val(as[0].addr_fact);
							zip_fact = '';
							focus_addr = '';
						}
						break;
					case 'cust':
						var as = _q_appendData("cust", "", true);
						if (as[0] != undefined && focus_addr != '') {
							$('#' + zip_fact).val(as[0].zip_fact);
							$('#' + focus_addr).val(as[0].addr_fact);
							zip_fact = '';
							focus_addr = '';
						}
						break;
					case 'ordb':
						var ordb = _q_appendData("ordb", "", true);
						if (ordb[0] != undefined) {
							$('#combPaytype').val(ordb[0].paytype);
							$('#txtPaytype').val(ordb[0].pay);
							$('#cmbTrantype').val(ordb[0].trantype);
							$('#cmbCoin').val(ordb[0].coin);
							$('#txtPost2').val(ordb[0].post);
							$('#txtAddr2').val(ordb[0].addr);
						}
						break;
					case q_name:
						if (q_cur == 4)
							q_Seek_gtPost();
						break;
				}
			}

			function btnOk() {
				$('#txtDatea').val($.trim($('#txtDatea').val()));
				if (checkId($('#txtDatea').val()) == 0) {
					alert(q_getMsg('lblDatea') + '錯誤。');
					return;
				}
				$('#txtOdate').val($.trim($('#txtOdate').val()));
				if (checkId($('#txtOdate').val()) == 0) {
					alert(q_getMsg('lblOdate') + '錯誤。');
					return;
				}
				t_err = q_chkEmpField([['txtNoa', q_getMsg('lblNoa')]]);
				if (t_err.length > 0) {
					alert(t_err);
					return;
				}
				
				//1030419 當專案沒有勾 BBM的取消和結案被打勾BBS也要寫入
				if(!$('#chkIsproj').prop('checked')){
					for (var j = 0; j < q_bbsCount; j++) {
						if($('#chkEnda').prop('checked'))
							$('#chkEnda_'+j).prop('checked','true');
						if($('#chkCancel').prop('checked'))
							$('#chkCancel_'+j).prop('checked','true')
					}
				}
				
				sum();
				
				if ($('#cmbKind').val() == '1') {
					for (var j = 0; j < q_bbsCount; j++) {
						$('#txtProductno_' + j).val($('#txtProductno1_' + j).val());
					}
				} else if ($('#cmbKind').val() == '2') {
					for (var j = 0; j < q_bbsCount; j++) {
						$('#txtProductno_' + j).val($('#txtProductno2_' + j).val());
					}
				} else {
					for (var j = 0; j < q_bbsCount; j++) {
						$('#txtProductno_' + j).val($('#txtProductno3_' + j).val());
					}
				}
				
				if(emp($('#txtTrandate').val())){
					$('#txtTrandate').val(q_cdn(q_date(),10));
				}
				for (var j = 0; j < q_bbsCount; j++) {
					if(!emp($('#txtProductno_' + j).val())&&emp($('#txtTrandate_'+j).val()))
						$('#txtTrandate_'+j).val($('#txtTrandate').val());
						
					if(q_cur==1)
						$('#txtOmount_'+j).val($('#txtMount_'+j).val());
				}
				
				if (q_cur == 1)
					$('#txtWorker').val(r_name);
				else
					$('#txtWorker2').val(r_name);
					
				var s1 = $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val();
				if (s1.length == 0 || s1 == "AUTO")
					q_gtnoa(q_name, replaceAll(q_getPara('sys.key_ordc') + $('#txtOdate').val(), '/', ''));
				else
					wrServer(s1);
			}

			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)
					return;
				q_box('ordc_tn_s.aspx', q_name + '_s', "550px", "400px", q_getMsg("popSeek"));
			}

			function combPaytype_chg() {
				var cmb = document.getElementById("combPaytype")
				if (!q_cur)
					cmb.value = '';
				else
					$('#txtPaytype').val(cmb.value);
				cmb.value = '';
			}
			
			function coin_chg() {
				var t_where = "where=^^ ('" + $('#txtOdate').val() + "' between bdate and edate) and coin='"+$('#cmbCoin').find("option:selected").text()+"' ^^";
				q_gt('flors', t_where, 0, 0, 0, "");
			}

			function combAddr_chg() {
				if (q_cur == 1 || q_cur == 2) {
					$('#txtAddr2').val($('#combAddr').find("option:selected").text());
					$('#txtPost2').val($('#combAddr').find("option:selected").val());
				}
			}
			
			var pbtn_bseq='';
			function bbsAssign() {
				for (var j = 0; j < q_bbsCount; j++) {
				    $('#lblNo_'+j).text(j+1);
					if (!$('#btnMinus_' + j).hasClass('isAssign')) {
						$('#btnProduct1_' + j).click(function() {
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length - 1];
							pbtn_bseq=n;
						});
						$('#btnProduct2_' + j).click(function() {
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length - 1];
							pbtn_bseq=n;
						});
						$('#btnProduct3_' + j).click(function() {
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length - 1];
							pbtn_bseq=n;
						});
						$('#txtUnit_' + j).change(function() {
							sum();
						});
						$('#txtMount_' + j).change(function() {
							sum();
						});
						$('#txtPrice_' + j).change(function() {
							sum();
						});
						$('#txtTotal_' + j).change(function() {
							sum();
						});
						$('#btnRc2record_' + j).click(function() {
							var n = replaceAll($(this).attr('id'),'btnRc2record_','');
                            q_box("z_rc2record.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";ordcno="+$('#txtNoa').val()+"&no2="+$('#txtNo2_' + n).val()+";" + r_accy, 'z_rc2record', "95%", "95%", q_getMsg('popPrint'));    
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
									
									$('#txtMount_'+n).val(round(q_mul(q_mul(q_div(t_lengthb,100),q_div(t_width,100)),t_lengthc),2));	
									break;
								case '+':
									//(長+寬)*2
									var t_meter=q_mul(q_mul(q_add(q_div(t_lengthb,100),q_div(t_width,100)),2),t_lengthc);
									$('#txtMount_'+n).val(t_meter);	
									$('#txtUnit_'+n).val('尺');	
									
									var t_length=0,t_short=0;
									if(t_length1>0) t_length++;
									if(t_length2>0) t_length++;
									if(t_short1>0) t_short++;
									if(t_short2>0) t_short++;
									$('#txtMemo_'+n).val(t_length+'長'+t_short+'短');
									$('#txtSpec_'+n).val(t_dime+'mm'+t_lengthb+'*'+t_width+'共'+t_lengthc+'片');
									break;
								case '-':
									//(長*寬)
									var t_meter=round(q_mul(q_mul(q_div(t_lengthb,100),q_div(t_width,100)),t_lengthc),2);
									$('#txtMount_'+n).val(t_meter);	
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
				product_change();
			}

			function btnIns() {
				_btnIns();
				$('#chkIsproj').attr('checked', true);
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val('AUTO');
				$('#txtOdate').val(q_date());
				$('#txtDatea').val(q_cdn(q_date(),20));
				$('#txtOdate').focus();
				$('#txtCno').val(z_cno);
				$('#txtAcomp').val(z_acomp);
				$('#txtAddr2').val(z_addr2);
				product_change();
				var t_where = "where=^^ 1=0 ^^ stop=100";
				q_gt('custaddr', t_where, 0, 0, 0, "");
				$('#cmbTaxtype').val(4);
				$('#cmbKind').val('1').change();
				$('#cmbKind').attr('disabled', 'disabled');
			}

			function btnModi() {
				var t_noa = $.trim($('#txtNoa').val());
				if (emp(t_noa))
					return;
				$('#cmbKind').attr('disabled', 'disabled');
				var t_where = "stop=1 where=^^ noa='" +t_noa+ "' ^^";
				q_gt('ordct', t_where, 0, 0, 0, "GetOrdct", r_accy);
			}
			
			function ModiDo(){
				_btnModi();
				$('#txtProduct').focus();
				product_change();
				if (!emp($('#txtTggno').val())) {
					var t_where = "where=^^ noa='" + $('#txtTggno').val() + "' ^^ stop=100";
					q_gt('custaddr', t_where, 0, 0, 0, "");
				}
			
			}

			function btnPrint() {
				q_box("z_ordcp.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";noa=" + $('#txtNoa').val() + ";" + r_accy, 'z_ordcp', "95%", "95%", q_getMsg('popPrint'));
			}

			function wrServer(key_value) {
				var i;
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
				_btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
			}

			function bbsSave(as) {
				if (!as['productno1'] && !as['productno2'] && !as['productno3']) {
					as[bbsKey[1]] = '';
					return;
				}
				q_nowf();
				as['datea'] = abbm2['datea'];
				as['kind'] = abbm2['kind'];
				as['tggno'] = abbm2['tggno'];
				as['odate'] = abbm2['odate'];
				as['trandate'] = abbm2['trandate'];
				return true;
			}

			function refresh(recno) {
				_refresh(recno);
				product_change();
				if (!emp($('#txtLcno').val())) {
					$('.import').show();
					$('#btnImport').val('進口欄位隱藏');
				} else {
					$('.import').hide();
					$('#btnImport').val('進口欄位顯示');
				}
			}

			function readonly(t_para, empty) {
				_readonly(t_para, empty);
				if (t_para) {
					$('#btnOrdb').attr('disabled', 'disabled');
					$('#combAddr').attr('disabled', 'disabled');
				} else {
					$('#btnOrdb').removeAttr('disabled');
					$('#combAddr').removeAttr('disabled');
				}
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

			function product_change() {
				if ($('#cmbKind').val() == '1') {
					for (var j = 0; j < q_bbsCount; j++) {
						$('#btnProduct1_' + j).show();
						$('#btnProduct2_' + j).hide();
						$('#btnProduct3_' + j).hide();
						$('#txtProductno1_' + j).show();
						$('#txtProductno2_' + j).hide();
						$('#txtProductno3_' + j).hide();
						$('#txtProductno1_' + j).val($('#txtProductno_' + j).val());
					}
				} else if ($('#cmbKind').val() == '2') {
					for (var j = 0; j < q_bbsCount; j++) {
						$('#btnProduct1_' + j).hide();
						$('#btnProduct2_' + j).show();
						$('#btnProduct3_' + j).hide();
						$('#txtProductno1_' + j).hide();
						$('#txtProductno2_' + j).show();
						$('#txtProductno3_' + j).hide();
						$('#txtProductno2_' + j).val($('#txtProductno_' + j).val());
					}
				} else {
					for (var j = 0; j < q_bbsCount; j++) {
						$('#btnProduct1_' + j).hide();
						$('#btnProduct2_' + j).hide();
						$('#btnProduct3_' + j).show();
						$('#txtProductno1_' + j).hide();
						$('#txtProductno2_' + j).hide();
						$('#txtProductno3_' + j).show();
						$('#txtProductno3_' + j).val($('#txtProductno_' + j).val());
					}
				}
			}

			function checkId(str) {
				if ((/^[a-z,A-Z][0-9]{9}$/g).test(str)) {//身分證字號
					var key = 'ABCDEFGHJKLMNPQRSTUVWXYZIO';
					var s = (key.indexOf(str.substring(0, 1)) + 10) + str.substring(1, 10);
					var n = parseInt(s.substring(0, 1)) * 1 + parseInt(s.substring(1, 2)) * 9 + parseInt(s.substring(2, 3)) * 8 + parseInt(s.substring(3, 4)) * 7 + parseInt(s.substring(4, 5)) * 6 + parseInt(s.substring(5, 6)) * 5 + parseInt(s.substring(6, 7)) * 4 + parseInt(s.substring(7, 8)) * 3 + parseInt(s.substring(8, 9)) * 2 + parseInt(s.substring(9, 10)) * 1 + parseInt(s.substring(10, 11)) * 1;
					if ((n % 10) == 0)
						return 1;
				} else if ((/^[0-9]{8}$/g).test(str)) {//統一編號
					var key = '12121241';
					var n = 0;
					var m = 0;
					for (var i = 0; i < 8; i++) {
						n = parseInt(str.substring(i, i + 1)) * parseInt(key.substring(i, i + 1));
						m += Math.floor(n / 10) + n % 10;
					}
					if ((m % 10) == 0 || ((str.substring(6, 7) == '7' ? m + 1 : m) % 10) == 0)
						return 2;
				} else if ((/^[0-9]{4}\/[0-9]{2}\/[0-9]{2}$/g).test(str)) {//西元年
					var regex = new RegExp("^(?:(?:([0-9]{4}(-|\/)(?:(?:0?[1,3-9]|1[0-2])(-|\/)(?:29|30)|((?:0?[13578]|1[02])(-|\/)31)))|([0-9]{4}(-|\/)(?:0?[1-9]|1[0-2])(-|\/)(?:0?[1-9]|1\\d|2[0-8]))|(((?:(\\d\\d(?:0[48]|[2468][048]|[13579][26]))|(?:0[48]00|[2468][048]00|[13579][26]00))(-|\/)0?2(-|\/)29))))$");
					if (regex.test(str))
						return 3;
				} else if ((/^[0-9]{3}\/[0-9]{2}\/[0-9]{2}$/g).test(str)) {//民國年
					str = (parseInt(str.substring(0, 3)) + 1911) + str.substring(3);
					var regex = new RegExp("^(?:(?:([0-9]{4}(-|\/)(?:(?:0?[1,3-9]|1[0-2])(-|\/)(?:29|30)|((?:0?[13578]|1[02])(-|\/)31)))|([0-9]{4}(-|\/)(?:0?[1-9]|1[0-2])(-|\/)(?:0?[1-9]|1\\d|2[0-8]))|(((?:(\\d\\d(?:0[48]|[2468][048]|[13579][26]))|(?:0[48]00|[2468][048]00|[13579][26]00))(-|\/)0?2(-|\/)29))))$");
					if (regex.test(str))
						return 4
				}
				return 0;
				//錯誤
			}

			function q_popPost(s1) {
				switch (s1) {
					case 'txtTggno':
						if (!emp($('#txtTggno').val())) {
							var t_where = "where=^^ noa='" + $('#txtTggno').val() + "' ^^ stop=100";
							q_gt('custaddr', t_where, 0, 0, 0, "");
						}
						break;
				}
			}

		</script>
		<style type="text/css">
			#dmain {
				overflow: hidden;
			}
			.dview {
				float: left;
				width: 30%;
				border-width: 0px;
			}
			.tview {
				margin: 0;
				padding: 2px;
				border: 1px black double;
				border-spacing: 0;
				font-size: medium;
				background-color: #FFFF66;
				color: blue;
				width: 100%;
			}
			.tview td {
				padding: 2px;
				text-align: center;
				border: 1px black solid;
			}
			.dbbm {
				float: left;
				width: 70%;
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
			.tbbm .tdZ {
				width: 2%;
			}
			.tbbm tr td span {
				float: right;
				display: block;
				width: 5px;
				height: 10px;
			}
			.tbbm tr td .lbl {
				float: right;
				color: blue;
				font-size: medium;
			}
			.tbbm tr td .lbl.btn {
				color: #4297D7;
				font-weight: bolder;
				font-size: medium;
			}
			.tbbm tr td .lbl.btn:hover {
				color: #FF8F19;
			}
			.tbbm td {
				margin: 0 -1px;
				padding: 0;
			}
			.tbbm td input[type="text"] {
				border-width: 1px;
				padding: 0px;
				margin: -1px;
			}
			.tbbm td input[type="button"] {
				float: left;
			}
			.tbbm select {
				border-width: 1px;
				padding: 0px;
				margin: -1px;
				font-size: medium;
			}
			.txt.c1 {
				width: 98%;
				float: left;
			}
			.txt.c2 {
				width: 37%;
				float: left;
			}
			.txt.c3 {
				width: 57%;
				float: left;
			}
			.txt.c4 {
				width: 18%;
				float: left;
			}
			.txt.c5 {
				width: 80%;
				float: left;
			}
			.txt.c6 {
				width: 25%;
			}
			.txt.c7 {
				width: 60%;
				float: left;
			}
			.txt.c8 {
				width: 48%;
				float: left;
			}
			.txt.num {
				text-align: right;
			}
			.dbbs {
				width: 1600px;
			}
			.tbbs a {
				font-size: medium;
			}
			.tbbs tr.error input[type="text"] {
				color: red;
			}
			.num {
				text-align: right;
			}
			input[type="text"], input[type="button"] {
				font-size: medium;
			}
			.txt.lef {
				float: left;
			}
			.import {
				background: #FFAA33;
			}
		</style>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();">
		<!--#include file="../inc/toolbar.inc"-->
		<div id='dmain' style="overflow:hidden;width: 1260px;">
			<div class="dview" >
				<table class="tview" id="tview">
					<tr>
						<td align="center" style="width:5%"><a id='vewChk'> </a></td>
						<td align="center" style="width:25%"><a id='vewOdate'> </a></td>
						<td align="center" style="width:25%"><a id='vewNoa'> </a></td>
						<td align="center" style="width:40%"><a id='vewTgg'> </a></td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox" style=''/></td>
						<td align="center" id='odate'>~odate</td>
						<td align="center" id='noa'>~noa</td>
						<td align="center" id='tggno tgg,4'>~tggno ~tgg,4</td>
					</tr>
				</table>
			</div>
			<div class='dbbm' >
				<table class="tbbm" id="tbbm" style="width: 872px;">
					<tr class="tr1">
						<td class="td1" style="width: 108px;"><span> </span><a id='lblKind' class="lbl"> </a></td>
						<td class="td2" style="width: 108px;"><select id="cmbKind" class="txt c1 lef"> </select></td>
						<td class="td3" style="width: 108px;"> </td>
						<td class="td3" style="width: 108px;"><span> </span><a id='lblOdate' class="lbl"> </a></td>
						<td class="td4" style="width: 108px;"><input id="txtOdate" type="text" class="txt c1 lef"/></td>
						<td style="width: 108px;"> </td>
						<td class="td5" style="width: 108px;"><span> </span><a id='lblDatea' class="lbl"> </a></td>
						<td class="td6" style="width: 108px;"><input id="txtDatea" type="text" class="txt c1 lef"/></td>
					</tr>
					<tr class="tr2">
						<td class="td1"><span> </span><a id="lblAcomp" class="lbl btn" > </a></td>
						<td class="td2" colspan="5">
							<input id="txtCno" type="text" class="txt c4 lef"/>
							<input id="txtAcomp"type="text" class="txt c5 lef" />
						</td>
						<td class="td7"><span> </span><a id='lblNoa' class="lbl"> </a></td>
						<td class="td8"><input id="txtNoa"	type="text" class="txt c1 lef"/></td>
					</tr>
					<tr class="tr3">
						<td class="td1"><span> </span><a id="lblTgg" class="lbl btn"> </a></td>
						<td class="td2" colspan="5">
							<input id="txtTggno" type="text" class="txt c4 lef"/>
							<input id="txtTgg" type="text" class="txt c5 lef"/>
						</td>
						<td class="td7"><span> </span><a id='lblTrantype' class="lbl"> </a></td>
						<td class="td8"><select id="cmbTrantype" class="txt c1 lef" name="D1" > </select></td>
					</tr>
					<tr class="tr3">
						<td class="td1"><span> </span><a id="lblSales" class="lbl btn"> </a></td>
						<td class="td2" colspan="2">
							<input id="txtSalesno" type="text" class="txt c2 lef"/>
							<input id="txtSales" type="text" class="txt c7 lef"/>
						</td>
						<td class="td4"><span> </span><a id='lblPaytype' class="lbl"> </a></td>
						<td class="td5" colspan='2'>
							<input id="txtPaytype" type="text" class="txt c8 lef"/>
							<select id="combPaytype" class="txt c8 lef" onchange='combPaytype_chg()'> </select>
						</td>
						<td class="td7"> </td>
						<!--<td class="td8"><input id="btnImport" type="button"/></td>-->
					</tr>
					<tr class="tr4">
						<td class="td1"><span> </span><a id='lblTel' class="lbl"> </a></td>
						<td class="td2" colspan='2'><input id="txtTel" type="text" class="txt c1 lef"/></td>
						<td class="td4"><span> </span><a id='lblFax' class="lbl"> </a></td>
						<td class="td5" colspan='2'><input id="txtFax" type="text" class="txt c1 lef"/></td>
					</tr>
					<tr class="tr5">
						<td class="td1"><span> </span><a id='lblAddr' class="lbl"> </a></td>
						<td class="td2"><input id="txtPost" type="text"	class="txt c1 lef"/></td>
						<td class="td3" colspan='4'>
							<input id="txtAddr" type="text" class="txt c1 lef" style="width: 98%;"/>
						</td>
						<td class="td1" style="display: none;"><span> </span><a id='lblOrdb' class="lbl btn"> </a></td>
						<td class="td2" style="display: none;"><input id="txtOrdbno" type="text" class="txt c1 lef" /></td>
					</tr>
					<tr class="tr5">
						<td class="td1"><span> </span><a id='lblAddr2' class="lbl"> </a></td>
						<td class="td2"><input id="txtPost2" type="text" class="txt c1 lef"/></td>
						<td class="td3" colspan='4' >
							<input id="txtAddr2" type="text" class="txt c1 lef" style="width: 412px;"/>
							<select id="combAddr" style="width: 20px" onchange='combAddr_chg()'> </select>
						</td>
						<td class="td7"><span> </span><a id='lblTrandate' class="lbl"> </a></td>
						<td class="td8"><input id="txtTrandate" type="text" class="txt c1 lef"/></td>
					</tr>
					<tr class="tr6">
						<td class="td1"><span> </span><a id='lblMoney' class="lbl"> </a></td>
						<td class="td2" colspan="2"><input id="txtMoney" type="text" class="txt num c1 lef" /></td>
						<td class="td3"><span> </span><a id='lblTax' class="lbl"> </a></td>
						<td class="td4"><input id="txtTax" type="text" class="txt num c1 lef" /></td>
						<td class="td5"><select id="cmbTaxtype" class="txt c1" onchange='sum()' > </select></td>
						<td class="td6"><span> </span><a id='lblTotal' class="lbl"> </a></td>
						<td class="td7"><input id="txtTotal" type="text" class="txt num c1 lef" /></td>
					</tr>
					<tr class="tr7 floata" style="display: none;">
						<td class="td1"><span> </span><a id='lblFloata' class="lbl"> </a></td>
						<td class="td2"><select id="cmbCoin" class="txt c1 lef" onchange='coin_chg()'> </select></td>
						<td class="td3"><input id="txtFloata" type="text" class="txt num c1 lef" /></td>
						<td class="td4"><span> </span><a id='lblTotalus' class="lbl"> </a></td>
						<td class="td5" colspan="2"><input id="txtTotalus" type="text" class="txt num c1 lef" /></td>
						<td class="td7"><span> </span><a id="lblApv" class="lbl"> </a></td>
						<td class="td8"><input id="txtApv" type="text" class="txt c1 lef" disabled="disabled" /></td>
					</tr>
					<tr class="tr8 import" style="display: none;">
						<td class="td1"><span> </span><a id='lblLcno' class="lbl"> </a></td>
						<td class="td2" colspan="2"><input id="txtLcno" type="text"	class="txt c1 lef"/></td>
						<td class="td4"><span> </span><a id='lblImportno' class="lbl"> </a></td>
						<td class="td5" colspan="2"><input id="txtImportno" type="text"	class="txt c1 lef"/></td>
						<td class="td7"> </td>
						<td class="td8"><!--<input id="btnSi" type="button"/>--></td>
					</tr>
					<tr class="tr8 import">
						<td class="td1"><span> </span><a id='lblEtd' class="lbl"> </a></td>
						<td class="td2" colspan="2"><input id="txtEtd" type="text"	class="txt c1 lef"/></td>
						<td class="td4"><span> </span><a id='lblEta' class="lbl"> </a></td>
						<td class="td5" colspan="2"><input id="txtEta" type="text"	class="txt c1 lef"/></td>
						<td class="td7"><span> </span><a id='lblOnboarddate' class="lbl"> </a></td>
						<td class="td8"><input id="txtOnboarddate" type="text"	class="txt c1 lef"/></td>
					</tr>
					<tr class="tr9">
						<td class="td1"><span> </span><a id='lblContract' class="lbl"> </a></td>
						<td class="td2" colspan="2"><input id="txtContract" type="text" class="txt c1 lef"/></td>
						<td class="td4"><span> </span><a id='lblWorker' class="lbl"> </a></td>
						<td class="td5"><input id="txtWorker" type="text" class="txt c1 lef" /></td>
						<td class="td6"><input id="txtWorker2" type="text" class="txt c1 lef" /></td>
						<td class="td7" align="right">
							<input id="chkIsproj" type="checkbox"/>
							<a id='lblIsproj' style="width: 50%;"> </a><span> </span>
						</td>
						<td class="td8" align="right">
							<input id="chkEnda" type="checkbox"/>
							<a id='lblEnd' style="width: 40%;"> </a><span> </span>
						</td>
					</tr>
					<tr class="tr10">
						<td class="td1"><span> </span><a id='lblMemo' class="lbl"> </a></td>
						<td class="td2" colspan='5'><input id="txtMemo" type="text" class="txt c1" /></td>
						<td class="td8" align="right">
                            <input id="chkCancel" type="checkbox"/>
                            <a id='lblCancel' style="width: 50%;">取消</a><span> </span>
                        </td>
					</tr>
				</table>
			</div>
		</div>
		<div class='dbbs' >
			<table id="tbbs" class='tbbs' border="1" cellpadding='2' cellspacing='1' style=' text-align:center;'>
				<tr style='color:White; background:#003366;' >
					<td  align="center" style="width:30px;">
                        <input class="btn"  id="btnPlus" type="button" value='+' style="font-weight: bold;"  />
                    </td>
                    <td align="center" style="width:20px;"> </td>
					<td align="center" style="width:180px;"><a id='lblProductno'> </a></td>
					<td align="center" style="width:200px;">品名/規格</td>
					<td align="center" style="width:40px;">型</td>
					<td align="center" style="width:100px;"><a id='lblMount_st'> </a></td>
					<td align="center" style="width:100px;"><a id='lblOmounts'> </a></td>
					<td align="center" style="width:60px;"><a id='lblUnit'> </a></td>
					<td align="center" style="width:100px;"><a id='lblPrices'> </a></td>
					<td align="center" style="width:100px;"><a id='lblTotals'> </a></td>
					<td align="center" style="width:80px;"><a id='lblTrandates'> </a></td>
					<td align="center" style="width:100px;"><a id='lblGemounts'> </a></td>
					<td align="center" style="width:150px;"><a id='lblMemos'> </a></td>
					<td align="center" style="width:45px;"><a id='lblRc2record'> </a></td>
					<td align="center" style="width:45px;"><a id='lblCancels'> </a></td>
					<td align="center" style="width:45px;"><a id='lblEndas'> </a></td>
				</tr>
				<tr style='background:#cad3ff;'>
					<td><input class="btn" id="btnMinus.*" type="button" value='-' style=" font-weight: bold;" /></td>
					<td><a id="lblNo.*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
					<td align="center">
						<input class="btn" id="btnProduct1.*" type="button" value='.' style=" font-weight: bold;float:left;" />
						<input class="btn" id="btnProduct2.*" type="button" value='.' style=" font-weight: bold;float:left;" />
						<input class="btn" id="btnProduct3.*" type="button" value='.' style=" font-weight: bold;float:left;" />
						<input class="txt c1" id="txtProductno1.*" type="text" style="width: 83%;"/>
						<input class="txt c1" id="txtProductno2.*" type="text" style="width: 83%;"/>
						<input class="txt c1" id="txtProductno3.*" type="text" style="width: 83%;"/>
						<input class="txt c1" id="txtProductno.*" type="hidden" />
						<input id="txtNo2.*" type="text" class="txt" style="width:60px; float: left;"/>
					</td>
					<td>
						<input id="txtProduct.*" type="text" class="txt c1"/>
						<input id="txtSpec.*" type="text" class="txt c1"/>
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
					<td><input id="txtMount.*" type="text" class="txt num c1" /></td>
					<td><input id="txtOmount.*" type="text" class="txt num c1" /></td>
					<td><input id="txtUnit.*" type="text" class="txt c1" style="text-align: center;"/></td>
					<td><input id="txtPrice.*" type="text" class="txt num c1" /></td>
					<td><input id="txtTotal.*" type="text" class="txt num c1" /></td>
					<td><input id="txtTrandate.*" type="text" class="txt c1"/></td>
					<td>
						<input class="txt num c1" id="txtC1.*" type="text" />
						<input class="txt num c1" id="txtNotv.*" type="text" />
					</td>
					<td>
						<input id="txtMemo.*" type="text" class="txt c1"/>
						<input class="txt" id="txtOrdbno.*" type="hidden" style="width:70%;" />
						<input class="txt" id="txtNo3.*" type="hidden" style="width:20%;" />
						<input id="recno.*" type="hidden" />
					</td>
					<td align="center">
						<input class="btn" id="btnRc2record.*" type="button" value='.' style=" font-weight: bold;" />
					</td>
					<td align="center"><input class="btn" id="chkCancel.*" type="checkbox"/></td>
					<td align="center"><input class="btn" id="chkEnda.*" type="checkbox"/></td>
				</tr>
			</table>
		</div>
		<input id="q_sys" type="hidden" />
	</body>
</html>