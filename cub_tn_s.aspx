<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title></title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"></script>
		<script src="css/jquery/ui/jquery.ui.widget.js"></script>
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"></script>
		<script type="text/javascript">
			var q_name = "cub_tn_s";
			var q_readonly = ['txtNoa', 'txtComp', 'txtTgg', 'txtMech'];
			aPop = new Array(
				['txtCno', '', 'acomp', 'noa,nick', 'txtCno,txtComp', 'acomp_b.aspx'],
				['txtMechno', '', 'mech', 'noa,mech', 'txtMechno,txtMech', 'mech_b.aspx'],
				['txtTggno', '', 'tgg', 'noa,nick', 'txtTggno,txtTgg', 'tgg_b.aspx']
			);
			$(document).ready(function() {
				main();
			});
			function main() {
				mainSeek();
				q_gf('', q_name);
			}

			function q_gfPost() {
				q_getFormat();
				q_langShow();
				bbmMask = [];
				q_mask(bbmMask);
				$('#txtNoa').focus();
				$('.readonly').attr('readonly',true);
			}

			function q_gtPost(t_name) {
				switch (t_name) {
				}
			}

			function q_seekStr() {
				var t_noa = $.trim($('#txtNoa').val());
				var t_cno = $.trim($('#txtCno').val());
				var t_tggno = $.trim($('#txtTggno').val());
				var t_mechno = $.trim($('#txtMechno').val());
				var t_where = " 1=1 " + q_sqlPara2("noa", t_noa) +
										q_sqlPara2("cno", t_cno) +
										q_sqlPara2("tggno", t_tggno) +
										q_sqlPara2("mechno", t_mechno) ;
				t_where = ' where=^^' + t_where + '^^ ';
				return t_where;
			}
		</script>
		<style type="text/css">
			.seek_tr {
				color: white;
				text-align: center;
				font-weight: bold;
				BACKGROUND-COLOR: #76a2fe
			}
			input{
				font-size:medium;
			}
			.readonly{
				color: green;
				background: rgb(237, 237, 238);
			}
		</style>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();">
		<div style='width:400px; text-align:center;padding:15px;' >
			<table id="seek" border="1" cellpadding='3' cellspacing='2' style='width:100%;' >
				<tr class='seek_tr'>
					<td class='seek' style="width:90px;"><a id='lblNoa'></a></td>
					<td><input class="txt" id="txtNoa" type="text" style="width:220px;" /></td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek' style="width:90px;"><a id='lblCno'></a></td>
					<td style="width:215px;">
						<input class="txt" id="txtCno" type="text" style="width:90px;" />
						&nbsp;
						<input class="txt readonly" id="txtComp" type="text" style="width:120px;" />
					</td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek' style="width:90px;"><a id='lblTggno'></a></td>
					<td style="width:215px;">
						<input class="txt" id="txtTggno" type="text" style="width:90px;" />
						&nbsp;
						<input class="txt readonly" id="txtTgg" type="text" style="width:120px;" />
					</td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek' style="width:90px;"><a id='lblMechno'></a></td>
					<td style="width:215px;">
						<input class="txt" id="txtMechno" type="text" style="width:90px;" />
						&nbsp;
						<input class="txt readonly" id="txtMech" type="text" style="width:120px;" />
					</td>
				</tr>
			</table>
			<!--#include file="../inc/seek_ctrl.inc"-->
		</div>
	</body>
</html>