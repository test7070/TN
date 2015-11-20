<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"></script>
		<script src="css/jquery/ui/jquery.ui.widget.js"></script>
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"></script>
		<script type="text/javascript">
			this.errorHandler = null;
			q_tables = 's';
			var toIns = true;
			var q_name = "cub";
			var q_readonly = ['txtNoa','txtComp','txtTgg','txtMech','txtWorker'];
			var q_readonlys = ['txtComp','txtOrdeno','txtNo2'];
			var bbmNum = [];
			var bbsNum = [
				['txtHard',10,0,1],['txtHweight',10,2,1],['txtMount', 10, 2, 1], 
				['txtLengthc', 10, 0, 1], ['txtLengthb', 10, 0, 1], ['txtDime', 10, 0, 1],['txtWidth', 10, 0, 1]
			];
			var bbmMask = [];
			var bbsMask = [['txtStyle', 'A']];
			q_sqlCount = 6;
			brwCount = 6;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'noa';
			q_desc = 1;
			brwCount2 = 5;
			aPop = new Array(
				['txtProductno_', 'btnProduct_', 'ucc', 'noa,product,spec', '0txtProductno_,txtProduct_,txtSpec_,txtStyle_', 'ucc_b.aspx'],
				['txtCustno_', 'btnCustno_', 'cust', 'noa,nick', 'txtCustno_', 'cust_b.aspx'],
				['txtCno', 'lblCno', 'acomp', 'noa,acomp', 'txtCno,txtComp', 'acomp_b.aspx'],
				['txtMechno', 'lblMechno', 'mech', 'noa,mech', 'txtMechno,txtMech', 'mech_b.aspx'],
				['txtTggno', 'lblTggno', 'tgg', 'noa,comp', 'txtTggno,txtTgg', 'tgg_b.aspx']
			);
			$(document).ready(function() {
				bbmKey = ['noa'];
				bbsKey = ['noa', 'noq'];
				q_brwCount();
				q_gt(q_name, q_content, q_sqlCount, 1, 0, 'LoadFirst', r_accy);
				q_gt('process', '', 0, 0, 0, "");
			});
			function main() {
				if (dataErr) {
					dataErr = false;
					return;
				}
				mainForm(0);
			}

			function sum() {
				for (var j = 0; j < q_bbsCount; j++) {
				}
			}

			function mainPost() {
				q_getFormat();
				bbmMask = [['txtDatea', r_picd], ['txtBdate', r_picd], ['txtEdate', r_picd]];
				bbsMask = [['txtDate2', r_picd],['txtDate3', r_picd], ['txtDatea', r_picd], ['txtBtime', '99:99'], ['txtEtime', '99:99']];
				q_mask(bbmMask);
				$('#btnOrde_tn').click(function(){
					if(q_cur==1 || q_cur==2){
						var t_cno = $.trim($('#txtCno').val());
						var t_tggno = $.trim($('#txtTggno').val());
						var t_process = $.trim($('#cmbProcessno :selected').text());
						var t_where = "(1=1) ";
						t_where += "and (";
						t_where += "((isnull(slit,0)=0) and (isnull(cut,0)=0) and (isnull(enda,0)=0)) ";
						t_where += " or ";
						var t_ordenoList = [];
						for(var k=0;k<abbsNow.length;k++){
							var thisOrdeno = $.trim(abbsNow[k].ordeno);
							var thisNo2 = $.trim(abbsNow[k].no2);
							t_ordenoList.push("'" + thisOrdeno+'-'+thisNo2+"'");
						}
						t_ordenoList = t_ordenoList.toString();
						if((q_cur==2) && (t_ordenoList.length > 0)){
							t_where += "((isnull(noa,'')+'-'+isnull(no2,'')) in ("+t_ordenoList+")) ";
						}else{
							t_where += "(1=0) ";
						}
						t_where += ")";
						t_where += "and (";
						if((t_cno.length >0)){
							t_where += "((charindex(N'"+t_cno+":',substring(isnull(sizea,''),0,charindex('^$^',isnull(sizea,'')))) > 0) and (charindex(N'"+t_process+"',substring(isnull(sizea,''),0,charindex('^$^',isnull(sizea,'')))) > 0)) "; //判斷廠別及加工方式
						}
						if((t_cno.length >0) && (t_tggno.length >0)){
							t_where += " and ";
							t_where += "((charindex(N'"+t_tggno+":',substring(sizea,charindex(N'^$^',isnull(sizea,'')),len(sizea))) > 0)) and (charindex(N'"+t_process+"',substring(sizea,charindex(N'^$^',isnull(sizea,'')),len(sizea))) > 0) "; //判斷委外廠商及加工方式
						}else{
							t_where += "";
						}
						if((t_cno.length==0) && (t_tggno.length==0)){
							t_where += " (1=0) ";
						}
						t_where += ") ";
						q_box("ordes_tn_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'ordes', "95%", "95%", q_getMsg('popOrde'));
					}
				});
			}

			function q_gtPost(t_name) {
				switch (t_name) {
					case 'process':
						var as = _q_appendData("process", "", true);
						if (as[0] != undefined) {
							var t_item = "@";
							for (i = 0; i < as.length; i++) {
								t_item = t_item + (t_item.length > 0 ? ',' : '') + as[i].noa + '@' + as[i].process;
							}
							q_cmbParse("cmbProcessno", t_item);
							if(abbm[q_recno]!= undefined)
						   		$("#cmbProcessno").val(abbm[q_recno].processno);
						}
						break;
					case q_name:
						if (q_cur == 4)
							q_Seek_gtPost();
						else if(q_cur==0 && toIns){
							var t_h1 = q_getHref();
							if($.trim(t_h1[0])==''){
								$('#btnIns').click();
							}
							toIns = false;
						}
						break;
				}
			}

			function q_stPost() {
				if (!(q_cur == 1 || q_cur == 2))
					return false;
			}

			function q_boxClose(s2) {
				var ret;
				switch (b_pop) {
					case 'ordes':
						if (q_cur > 0 && q_cur < 4) {
							if (!b_ret || b_ret.length == 0) {
								b_pop = '';
								return;
							}
							for(var k=0;k<q_bbsCount;k++){
								$('#btnMinus_'+k).click();
							}
							if (b_ret && b_ret[0] != undefined) {
								ret = q_gridAddRow(bbsHtm, 'tbbs', 
										'txtCustno,txtClass,txtProductno,txtProduct,txtUnit,txtWidth,txtLengthb,txtLengthc,txtDime,txtClass,txtStyle,txtSpec,txtOrdeno,txtNo2,txtMount',
										b_ret.length, b_ret,
										'custno,class,productno,product,unit,width,lengthb,lengthc,dime,class,style,spec,noa,no2,mount', 'txtOrdeno,txtNo2');
							}
							sum();
							b_ret = '';
						}
						break;
					case q_name + '_s':
						q_boxClose2(s2);
						break;
				}
				b_pop = '';
			}

			function btnIns() {
				_btnIns();
				$('#txtNoa').val('AUTO');
				$('#txtDatea').val(q_date());
				$('#txtDatea').focus();
			}

			function btnModi() {
				toIns = false;
				if (emp($('#txtNoa').val()))
					return;
				_btnModi();
				$('#txtDatea').focus();
			}

			function btnPrint() {
				q_box('z_cubp_tn.aspx' + "?;;;noa=" + trim($('#txtNoa').val()) + ";" + r_accy, '', "95%", "95%", q_getMsg("popPrint"));
			}

			function btnOk() {
				toIns = false;
				if ($('#txtDatea').val().length == 0 || !q_cd($('#txtDatea').val())) {
					alert(q_getMsg('lblDatea') + '錯誤。');
					return;
				}
				sum();
				var t_worker = $.trim($('#txtWorker').val());
				if(t_worker.length == 0){
					$('#txtWorker').val(r_name);
				}
				var thisCno = $.trim($('#txtCno').val());
				var thisComp = $.trim($('#txtComp').val());
				var thisTggno = $.trim($('#txtTggno').val());
				if((thisCno.length ==0) && (thisTggno.length==0)){
					alert('請輸入[' + q_getMsg('lblCno') + '] 或 [' + q_getMsg('lblTggno') + ']');
					return;
				}
				for(var k=0;k<q_bbsCount;k++){
					$('#txtCno_' + k).val(thisCno);
					$('#txtComp_' + k).val(thisComp);
				}
				
				var t_process = $.trim($('#cmbProcessno :selected').text());
				$('#txtProcess').val(t_process);
				
				var t_noa = trim($('#txtNoa').val());
				var t_date = trim($('#txtDatea').val());
				if (t_noa.length == 0 || t_noa == "AUTO")
					q_gtnoa(q_name, replaceAll(q_getPara('sys.key_cub') + (t_date.length == 0 ? q_date() : t_date), '/', ''));
				else
					wrServer(t_noa);
			}

			function wrServer(key_value) {
				var i;
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
				_btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
			}

			function bbsSave(as) {
				if (!as['custno']) {
					as[bbsKey[1]] = '';
					return;
				}
				q_nowf();
				as['noa'] = abbm2['noa'];
				return true;
			}

			function refresh(recno) {
				_refresh(recno);
			}

			function readonly(t_para, empty) {
				_readonly(t_para, empty);
				if(toIns){
					q_gt(q_name, '', 0, 0, 0, '', r_accy);
				}
			}

			function bbsAssign() {
				for (var i = 0; i < q_bbsCount; i++) {
					$('#lblNo_' + i).text(i + 1);
					if (!$('#btnMinus_' + i).hasClass('isAssign')) {
						$('#chkSlit_' + i).change(function(){
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length-1];
							if($(this).prop('checked')){
								$('#txtDate2_' + n).val(q_date());
								var timeDate= new Date();
								var tHours = timeDate.getHours();
								var tMinutes = timeDate.getMinutes();
								$('#txtBtime_' + n).val(padL(tHours, '0', 2)+':'+padL(tMinutes, '0', 2));
								$('#txtProduct2_'+n).val(r_name);
							}else{
								$('#txtDate2_' + n).val('');
								$('#txtBtime_' + n).val('');
								$('#txtProduct2_'+n).val('');
							}
							CountHard(n);
						});
						$('#chkCut_' + i).change(function(){
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length-1];
							if($(this).prop('checked')){
								var thisDate3 = $.trim($('#txtDate3_' + n).val());
								if(thisDate3.length == 0){
									$('#txtDate3_' + n).val(q_date());
								}
								var thisEtime = $.trim($('#txtEtime_' + n).val());
								if(thisEtime.length==0){
									var timeDate= new Date();
									var tHours = timeDate.getHours();
									var tMinutes = timeDate.getMinutes();
									$('#txtEtime_' + n).val(padL(tHours, '0', 2)+':'+padL(tMinutes, '0', 2));
								}
							}else{
								$('#txtDate3_' + n).val('');
								$('#txtEtime_' + n).val('');
							}
							CountHard(n);
						});
						$('#txtDate2_'+i).focusout(function(){
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length-1];
							CountHard(n);
						});
						$('#txtBtime_'+i).focusout(function(){
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length-1];
							CountHard(n);
						});
						$('#txtDate3_'+i).focusout(function(){
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length-1];
							CountHard(n);
						});
						$('#txtEtime_'+i).focusout(function(){
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length-1];
							CountHard(n);
						});
						
						//控制尺寸光標與div顯示與隱藏
						$('#tbbs td').children("input:text").each(function() {
							$(this).focusin(function() {
								if(!($(this).attr('id').split('_')[0]=='txtStyle' || $(this).attr('id').split('_')[0]=='txtMount'))
									$('.tn_style').hide();
							});
						});
						
						$('#txtMount_' + i).select(function() {
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length - 1];
							if (q_cur == 1 || q_cur == 2){
								$('#textLengthb_'+n).focus();
								$('#textLengthb_'+n).select();	
							}
						});
						$('#txtMount_' + i).focus(function() {
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length - 1];
							if (q_cur == 1 || q_cur == 2){
								$('#textLengthb_'+n).focus();
								$('#textLengthb_'+n).select();	
							}
						});
						
						$('#txtStyle_' + i).focusout(function() {
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
						
						$('#textLengthb_' + i).change(function() {
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length - 1];
							if (q_cur == 1 || q_cur == 2){
								if($('#txtStyle_'+n).val()=='+'){
									$('#textLength1_'+n).val($('#textLengthb_' + n).val());
									$('#textLength2_'+n).val($('#textLengthb_' + n).val());
								}
							}
						});
						
						$('#textWidth_' + i).change(function() {
							var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length - 1];
							if (q_cur == 1 || q_cur == 2){
								if($('#txtStyle_'+n).val()=='+'){
									$('#textShort1_'+n).val($('#textWidth_' + n).val());
									$('#textShort2_'+n).val($('#textWidth_' + n).val());
								}
							}
						});
						
						$('#btnStyleok_' + i).click(function() {
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
							
							$('#tn_style_'+n).hide();
							$('#txtMount_'+n).focus();
							$('#txtMount_'+n).select();
						});
						
					}
				}
				_bbsAssign();
			}

			function CountHard(n){
				var bdatea = $.trim($('#txtDate2_'+n).val());
				var edatea = $.trim($('#txtDate3_'+n).val());
				var btimea = $.trim($('#txtBtime_'+n).val());
				var etimea = $.trim($('#txtEtime_'+n).val());
				if((bdatea.length==0) || (edatea.length==0) || (btimea.length==0) || (etimea.length==0))
					return;
				bdatea = (parseInt(bdatea.substring(0,3))+1911)+bdatea.substring(3);
				edatea = (parseInt(edatea.substring(0,3))+1911)+edatea.substring(3);
				var oldtime=Date.parse(bdatea+' ' + btimea);
				var newtime=Date.parse(edatea+' ' + etimea);
				$('#txtHard_'+n).val(dec(q_div(q_div(q_sub(newtime,oldtime),1000),60)));
			}

			function q_appendData(t_Table) {
				return _q_appendData(t_Table);
			}

			function btnSeek() {
				_btnSeek();
			}

			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)
					return;
				q_box('cub_tn_s.aspx', q_name + '_s', "500px", "350px", q_getMsg("popSeek"));
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
				toIns = false;
				_btnDele();
			}

			function btnCancel() {
				toIns = false;
				_btnCancel();
			}

			function onPageError(error) {
				alert("An error occurred:\r\n" + error.Message);
			}
			
			function btnMinus(id) {
				_btnMinus(id);
			}

			function btnPlus(org_htm, dest_tag, afield) {
				_btnPlus(org_htm, dest_tag, afield);
			}

			function btnPlut(org_htm, dest_tag, afield) {
				_btnPlus(org_htm, dest_tag, afield);
			}

			function q_popPost(id) {
				switch (id) {
					case 'txtProductno_':
						$('#txtClass_' + b_seq).focus();
						break;
					default:
						break;
				}
			}
		</script>
		<style type="text/css">
			#dmain {
				/*overflow: hidden;*/
			}
			.dview {
				float: left;
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
			.tbbm tr td {
				width: 9%;
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
				font-size: medium;
			}
			.tbbm tr td .lbl.btn:hover {
				color: #FF8F19;
			}
			.txt.c1 {
				width: 95%;
				float: left;
			}
			.num {
				text-align: right;
			}
			.tbbm td {
				margin: 0 -1px;
				padding: 0;
			}
			.tbbm select {
				font-size: medium;
			}
			.tbbm td input[type="text"] {
				border-width: 1px;
				padding: 0px;
				margin: -1px;
				float: left;
			}
			input[type="text"], input[type="button"] {
				font-size: medium;
			}
			.dbbs {
				width: 1730px;
			}
			.dbbs .tbbs {
				margin: 0;
				padding: 2px;
				border: 2px lightgrey double;
				border-spacing: 1;
				border-collapse: collapse;
				font-size: medium;
				color: blue;
				background: lightgrey;
				width: 100%;
			}
			.dbbs .tbbs tr {
				height: 35px;
			}
			.dbbs .tbbs tr td {
				text-align: center;
				border: 2px lightgrey double;
			}
			.dbbs .tbbs select {
				border-width: 1px;
				padding: 0px;
				margin: -1px;
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
			<div class="dview" id="dview" >
				<table class="tview" id="tview" >
					<tr>
						<td style="width:20px; color:black;"><a id='vewChk'> </a></td>
						<td style="width:80px; color:black;"><a id='vewNoa'> </a></td>
						<td style="width:100px; color:black;"><a id='vewDatea'> </a></td>
						<td style="width:100px; color:black;">加工方式</td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox" style=''/></td>
						<td id='noa' style="text-align: center;">~noa</td>
						<td id='datea' style="text-align: center;">~datea</td>
						<td id='process' style="text-align: center;">~process</td>
					</tr>
				</table>
			</div>
			<div class='dbbm'>
				<table class="tbbm" id="tbbm">
					<tr style="height:1px;">
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
						<td><span> </span><a id="lblDatea" class="lbl"> </a></td>
						<td><input id="txtDatea" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblNoa" class="lbl"> </a></td>
						<td><input id="txtNoa" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblProcessno" class="lbl" > </a></td>
						<td>
							<select id="cmbProcessno" class="txt c1"> </select>
							<input id="txtProcess" type="hidden"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id="lblCno" class="lbl btn"> </a></td>
						<td colspan="2">
							<input id="txtCno" type="text" style="width:30%;"/>
							<input id="txtComp" type="text" style="width:65%;"/>
						</td>
						<td><span> </span><a id="lblTggno" class="lbl btn"> </a></td>
						<td colspan="2">
							<input id="txtTggno" type="text" style="width:30%;"/>
							<input id="txtTgg" type="text" style="width:65%;"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id="lblMechno" class="lbl btn"> </a></td>
						<td colspan="2">
							<input id="txtMechno" type="text" style="width:30%;"/>
							<input id="txtMech" type="text" style="width:65%;"/>
						</td>
						<td></td>
						<td><input type="button" id="btnOrde_tn"></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblWorker" class="lbl"> </a></td>
						<td><input id="txtWorker" type="text" class="txt c1"/></td>
					</tr>
				</table>
			</div>
			<div class='dbbs'>
				<table id="tbbs" class='tbbs'>
					<tr style='color:white; background:#003366;' >
						<td style="width:20px;">
							<input id="btnPlus" type="button" style="font-size: medium; font-weight: bold;" value="＋"/>
						</td>
						<td style="width:20px;"> </td>
						<td style="width:100px;"><a id='lbl_custno'> </a></td>
						<td style="width:120px;"><a id='lbl_productno'> </a></td>
						<td style="width:300px;"><a id='lbl_product'> </a>/<a id='lbl_spec'> </a></td>
						<td align="center" style="width:40px;">型</td>
						<td align="center" style="width:100px;">數量</td>
						<td align="center" style="width:50px;">單位</td>
						<td style="width:20px; text-align: center;">開工</td>
						<td style="width:20px; text-align: center;">完工</td>
						<td style="width:80px; text-align: center;">開工日期</td>
						<td style="width:80px; text-align: center;">開工時間</td>
						<td style="width:80px; text-align: center;">完工日期</td>
						<td style="width:80px; text-align: center;">完工時間</td>
						<td style="width:80px; text-align: center;">工時(分)</td>
						<td style="width:80px; text-align: center;">工作人員</td>
						<td style="width:150px;"><a id='lbl_memo'> </a></td>
						<td style="width:180px;"><a id='lbl_ordeno'> </a></td>
					</tr>
					<tr style='background:#cad3ff;'>
						<td align="center">
							<input id="btnMinus.*" type="button" style="font-size: medium; font-weight: bold;" value="－"/>
							<input id="txtNoq.*" type="text" style="display: none;"/>
						</td>
						<td><a id="lblNo.*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
						<td>
							<input id="btnCustno.*" type="button" style="float:left;width:5%;"/>
							<input id="txtCustno.*" type="text" class="txt" style="width:70%;"/>
						</td>
						<td><input id="txtProductno.*" type="text" class="txt c1"/></td>
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
						<td><input id="txtMount.*" type="text" class="txt num" style="width:95%;"/></td>
						<td><input id="txtUnit.*" type="text" style="width:90%;text-align: center;"/></td>
						<td><input id="chkSlit.*" type="checkbox"/></td>
						<td><input id="chkCut.*" type="checkbox"/></td>
						<td><input id="txtDate2.*" type="text" class="txt c1"/></td>
						<td><input id="txtBtime.*" type="text" class="txt c1"/></td>
						<td><input id="txtDate3.*" type="text" class="txt c1"/></td>
						<td><input id="txtEtime.*" type="text" class="txt c1"/></td>
						<td><input id="txtHard.*" type="text" class="txt c1 num"/></td>
						<td><input id="txtProduct2.*" type="text" class="txt c1"/></td>
						<td><input id="txtMemo.*" type="text" class="txt c1"/></td>
						<td>
							<input id="txtOrdeno.*" type="text" class="txt" style="width:65%;"/>
							<input id="txtNo2.*" type="text" class="txt" style="width:25%;"/>
						</td>
					</tr>
				</table>
			</div>
		<input id="q_sys" type="hidden" />
	</body>
</html>