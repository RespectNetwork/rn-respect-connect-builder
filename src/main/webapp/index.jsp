<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>

<head>

	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Respect Connect Button Builder</title>
	<link rel="stylesheet" target="_blank" href="style.css" TYPE="text/css" MEDIA="screen">
	<script type="text/javascript" src="xdi.js"></script>
	<script type="text/javascript" src="jquery-2.0.3.min.js"></script>
	<script type="text/javascript" src="lodash.compat.min.js"></script>

	<script type="text/javascript">

		function clickdiscovercloudnumber(url) {

			xdi.discovery(

				$('#requestingparty').val(),
				function(discovery) {
					$('#requestingparty').val(discovery.cloudNumber());
					$('#xdiendpoint').val(discovery.xdiEndpoint());
				},
				function(errorText) {
					$('#requestingparty').val(errorText);
				},
				url
			);
		}

		function clickdiscovercloudnumberfromprod() {

			return clickdiscovercloudnumber("http://mycloud.neustar.biz:12220/");
		}

		function clickdiscovercloudnumberfromote() {

			return clickdiscovercloudnumber("http://mycloud-ote.neustar.biz:12220/");
		}

		function clickbuildaddresssingleton() {

			$('#metalinkcontractaddress').val($('#requestingparty').val() + "{$to}" + $('#requestingparty').val() + "$from" + $('#templateid').val() + "$do");
			$('#linkcontracttemplateaddress').val($('#requestingparty').val() + "{$from}" + $('#templateid').val() + "$do");
		}

		function clickbuildaddresscollection() {

			var guid = xdi.util.guid();

			$('#metalinkcontractaddress').val($('#requestingparty').val() + "{$to}" + $('#requestingparty').val() + "$from" + $('#templateid').val() + "[$do]" + "!:uuid:" + guid);
			$('#linkcontracttemplateaddress').val($('#requestingparty').val() + "{$from}" + $('#templateid').val() + "[$do]" + "!:uuid:" + guid);
		}

		function clickretrieveprivatekey() {

			if ($('#requestingparty').val() === "") { $("#privatekey").val("No requesting party."); return; }
			if ($('#xdiendpoint').val() === "") { $("#privatekey").val("No XDI endpoint."); return; }

			var message = xdi.message($('#requestingparty').val());
			message.toAddress("(" + $('#requestingparty').val() + ")");
			message.linkContract("$do");
			message.secretToken($('#secrettoken').val());
			message.operation("$get", "$msg$sig$keypair<$private><$key>");

			message.send(

				$('#xdiendpoint').val(),
				function(response) {
					var context = response.root().context("$msg$sig$keypair<$private><$key>&");
					var literal = context === null ? null : context.literal();
					var data = literal === null ? null : literal.data();
					$("#privatekey").val(data);
				},
				function(errorText) {
					$("#privatekey").val(errorText);
				}
			);
		}

		function clickbuildlinkcontracttemplatexdi() {

			$.ajax({

				url: "BuildLinkContractTemplateXDI?" + $('#form').serialize(),
				type: 'post',
				success: function(data) {
					var text = JSON.stringify(data, null, "  ");
					$('#linkcontracttemplatexdiresult').text(text);
				},
				error: function(data) {
					var text = "error: " + data.statusText;
					$('#linkcontracttemplatexdiresult').text(text);
				}
			});
		}

		function clickdeletelinkcontracttemplatexdi() {

			var message = xdi.message($('#requestingparty').val());
			message.toAddress("(" + $('#requestingparty').val() + ")");
			message.linkContract("$do");
			message.secretToken($('#secrettoken').val());
			message.operation("$del", $('#linkcontracttemplateaddress').val());

			message.send(

				$('#xdiendpoint').val(),
				function(response) {
					alert("Link Contract Template has been successfully deleted.");
				},
				function(errorText) {
					alert(errorText);
				}
			);
		}

		function clickinstalllinkcontracttemplatexdi() {

			var graph = xdi.graph();
			graph.deserializeXDIJSON($('#linkcontracttemplatexdiresult').text());

			var statements = graph.statements();

			var message = xdi.message($('#requestingparty').val());
			message.toAddress("(" + $('#requestingparty').val() + ")");
			message.linkContract("$do");
			message.secretToken($('#secrettoken').val());
			
			for (var i in statements) message.operation("$set", statements[i]);
			message.operation("$set", xdi.parser.parseStatement("$public$do/$get/" + $('#linkcontracttemplateaddress').val()));

			message.send(

				$('#xdiendpoint').val(),
				function(response) {
					alert("Link Contract Template has been successfully installed.");
				},
				function(errorText) {
					alert(errorText);
				}
			);
		}

		function clickbuildmetalinkcontractxdi() {

			$.ajax({

				url: "BuildMetaLinkContractXDI?" + $('#form').serialize(),
				type: 'post',
				success: function(data) {
					var text = JSON.stringify(data, null, "  ");
					$('#metalinkcontractxdiresult').text(text);
				},
				error: function(data) {
					var text = "error: " + data.statusText;
					$('#metalinkcontractxdiresult').text(text);
				}
			});
		}

		function clickdeletemetalinkcontractxdi() {

			var message = xdi.message($('#requestingparty').val());
			message.toAddress("(" + $('#requestingparty').val() + ")");
			message.linkContract("$do");
			message.secretToken($('#secrettoken').val());
			message.operation("$del", $('#metalinkcontractaddress').val());

			message.send(

				$('#xdiendpoint').val(),
				function(response) {
					alert("Meta Link Contract has been successfully deleted.");
				},
				function(errorText) {
					alert(errorText);
				}
			);
		}

		function clickinstallmetalinkcontractxdi() {

			var graph = xdi.graph();
			graph.deserializeXDIJSON($('#metalinkcontractxdiresult').text());

			var statements = graph.statements();

			var message = xdi.message($('#requestingparty').val());
			message.toAddress("(" + $('#requestingparty').val() + ")");
			message.linkContract("$do");
			message.secretToken($('#secrettoken').val());
			
			for (var i in statements) message.operation("$set", statements[i]);

			message.send(

				$('#xdiendpoint').val(),
				function(response) {
					alert("Meta Link Contract has been successfully installed.");
				},
				function(errorText) {
					alert(errorText);
				}
			);
		}

		function clickbuildmessagexdiandhtml(url) {

			$.ajax({

				url: "BuildMessageXDI?" + $('#form').serialize(),
				type: 'post',
				success: function(data) {
					var text = JSON.stringify(data, null, "  ");
					$('#messagexdiresult').text(text);
				},
				error: function(data) {
					var text = "error: " + data.statusText;
					$('#messagexdiresult').text(text);
				}
			});

			$.ajax({

				url: "BuildMessageXDI?" + $('#form').serialize(),
				type: 'post',
				success: function(data) {
					var xdimessage = JSON.stringify(data);
					var returnurl = $('#form input[name=returnUrl]').val();
					var text = '';
					text += '<form action="' + url + '" method="post">\n';
					text += '<input type="image" src="' + 'images/respectconnect.png">\n';
					text += '<input type="hidden" name="xdimessage" value="' + _.escape(xdimessage) + '">\n';
					text += '<input type="hidden" name="returnurl" value="' + _.escape(returnurl) + '">\n';
					text += '</form>\n';
					$('#messagehtmlresult').text(text);
				},
				error: function(data) {
					var text = "error: " + data.statusText;
					$('#messagehtmlresult').text(text);
				}
			});
		}

		function clickbuildmessagexdiandhtmlforprod(url) {

			return clickbuildmessagexdiandhtml("https://respectconnect.respectnetwork.net/respectconnect/");
		}

		function clickbuildmessagexdiandhtmlforote(url) {

			return clickbuildmessagexdiandhtml("https://respectconnect-dev.respectnetwork.net/respectconnect/");
		}

		$(document).ready(function() {

			$("#buttondiscovercloudnumberfromprod").on("click", clickdiscovercloudnumberfromprod);
			$("#buttondiscovercloudnumberfromote").on("click", clickdiscovercloudnumberfromote);
			$("#buttonbuildaddresssingleton").on("click", clickbuildaddresssingleton);
			$("#buttonbuildaddresscollection").on("click", clickbuildaddresscollection);
			$("#buttonretrieveprivatekey").on("click", clickretrieveprivatekey);
			$("#buttonbuildlinkcontracttemplatexdi").on("click", clickbuildlinkcontracttemplatexdi);
			$("#buttondeletelinkcontracttemplatexdi").on("click", clickdeletelinkcontracttemplatexdi);
			$("#buttoninstalllinkcontracttemplatexdi").on("click", clickinstalllinkcontracttemplatexdi);
			$("#buttonbuildmetalinkcontractxdi").on("click", clickbuildmetalinkcontractxdi);
			$("#buttondeletemetalinkcontractxdi").on("click", clickdeletemetalinkcontractxdi);
			$("#buttoninstallmetalinkcontractxdi").on("click", clickinstallmetalinkcontractxdi);
			$("#buttonbuildmessagexdiandhtmlforprod").on("click", clickbuildmessagexdiandhtmlforprod);
			$("#buttonbuildmessagexdiandhtmlforote").on("click", clickbuildmessagexdiandhtmlforote);
		});

	</script>

</head>

<body>

	<form id="form">

	<div id="header">

		<table>
		<tr>
		<td>
		<img id="applogo" src="images/logo.png">
		</td><td>
		<span id="appname">Respect Connect Button Builder</span>
		</tr>
		</table>

	</div>

	<div id="main">

	<% if (request.getAttribute("error") != null) { %>

		<p style="font-family: monospace; white-space: pre; color: red;"><%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %></p>

	<% } %>

	<h1>Step 1: Basic Information about the Requesting Party</h1>

		<div class="step">

		<table cellspacing="0" cellpadding="5" border="0">
		<tr>
		<td valign="top">Requesting Party:</td>
		<td>
		<input type="text" name="requestingParty" id="requestingparty" size="80" value="@acmebread">
		<input type="hidden" name="xdiEndpoint" id="xdiendpoint"><br>
		<input type="button" id="buttondiscovercloudnumberfromprod" value="Discover Cloud Number from PROD">
		<input type="button" id="buttondiscovercloudnumberfromote" value="Discover Cloud Number from OTE">
		</td>
		</tr>
		<tr>
		<td>Template ID:</td><td><input type="text" name="templateId" id="templateid" size="80" value="+registration"></td>
		</tr>
		<tr>
		<td valign="top">Address of Link Contract Template:</td>
		<td>
		<textarea name="linkContractTemplateAddress" id="linkcontracttemplateaddress" rows="3" cols="80"></textarea><br>
		</td>
		</tr>
		<tr>
		<td valign="top">Address of Meta Link Contract:</td>
		<td>
		<textarea name="metaLinkContractAddress" id="metalinkcontractaddress" rows="3" cols="80"></textarea><br>
		<input type="button" id="buttonbuildaddresssingleton" value="Build Singleton Address">
		<input type="button" id="buttonbuildaddresscollection" value="Build Collection Address">
		</td>
		</tr>
		<tr>
		</tr>
		<tr>
		<td>Requesting Party Secret Token:</td><td><input type="text" name="secretToken" id="secrettoken" size="80" value="bestbread"></td>
		</tr>
		<tr>
		<td>Private Key for Signature:</td>
		<td>
		<textarea name="privateKey" id="privatekey" cols="50" rows="3"></textarea><br>
		<input type="button" id="buttonretrieveprivatekey" value="Retrieve Private Key">
		</td>
		</tr>
		<tr>
		<td>Request Cloud Name:</td><td><input type="checkbox" name="requestCloudName"></td>
		</tr>
		<tr>
		<td>Request Attributes:</td><td><textarea name="requestAttributes" cols="50" rows="3">&lt;+name&gt;</textarea></td>
		</tr>
		</table>

		</div>

	<table cellpadding="10" width="100%">
	<tr>
	<td valign="top" width="50%">

	<h1>Step 2: Build and Install XDI Link Contract Template</h1>

		<div class="step">

		<p><input type="button" id="buttonbuildlinkcontracttemplatexdi" value="Build XDI Link Contract Template"></p>
	
		<div style="display: table; border-spacing: 10px;">
		<div style="display: table-row;">
		<div style="display: table-cell;" class="linkcontracttemplatexdiheading">
			XDI Link Contract Template
		</div>
		</div>
		<div style="display: table-row;">
		<div style="display: table-cell; width: 400px; max-width: 400px;" class="result">
			<div id="linkcontracttemplatexdiresult"></div>
		</div>
		</div>
		</div>

		<p><input type="button" id="buttondeletelinkcontracttemplatexdi" value="Delete Old XDI Link Contract Template"></p>
		<p><input type="button" id="buttoninstalllinkcontracttemplatexdi" value="Install XDI Link Contract Template"></p>

		</div>

	</td><td valign="top" width="50%">

	<h1>Step 3: Build and Install XDI Meta Link Contract</h1>

		<div class="step">

		<p><input type="button" id="buttonbuildmetalinkcontractxdi" value="Build XDI Meta Link Contract"></p>
	
		<div style="display: table; border-spacing: 10px;">
		<div style="display: table-row;">
		<div style="display: table-cell;" class="metalinkcontractxdiheading">
			XDI Meta Link Contract
		</div>
		</div>
		<div style="display: table-row;">
		<div style="display: table-cell; width: 400px; max-width: 400px;" class="result">
			<div id="metalinkcontractxdiresult"></div>
		</div>
		</div>
		</div>

		<p><input type="button" id="buttondeletemetalinkcontractxdi" value="Delete Old XDI Meta Link Contract"></p>
		<p><input type="button" id="buttoninstallmetalinkcontractxdi" value="Install XDI Meta Link Contract"></p>

		</div>

	</td>
	</tr>
	</table>

	<h1>Step 4: Build XDI Message and install Message HTML on your Website</h1>

		<div class="step">

		<p>Return URL: <input type="text" name="returnUrl" size="80" value="https://yourwebsite.com/returnurl.html"></p>
		<p>
		<input type="button" id="buttonbuildmessagexdiandhtmlforprod" value="Build XDI Message and HTML for PROD">
		<input type="button" id="buttonbuildmessagexdiandhtmlforote" value="Build XDI Message and HTML for OTE">
		</p>

		</div>

	<table cellpadding="10" width="100%">
	<tr>
	<td valign="top" width="50%">

		<div class="step">
	
		<div style="display: table; border-spacing: 10px;">
		<div style="display: table-row;">
		<div style="display: table-cell;" class="messagexdiheading">
			XDI Message
		</div>
		</div>
		<div style="display: table-row;">
		<div style="display: table-cell; width: 400px; max-width: 400px;" class="result">
			<div id="messagexdiresult"></div>
		</div>
		</div>
		</div>

		</div>

	</td><td valign="top" width="50%">

		<div class="step">

		<div style="display: table; border-spacing: 10px;">
		<div style="display: table-row;">
		<div style="display: table-cell;" class="messagehtmlheading">
			Message HTML
		</div>
		</div>
		<div style="display: table-row;">
		<div style="display: table-cell; width: 400px; max-width: 400px;" class="result">
			<div id="messagehtmlresult"></div>
		</div>
		</div>
		</div>

		</div>

	</td>
	</tr>
	</table>

	<h1>Step 5: Install and integrate the Respect Connect SDK with your Website</h1>

		<div class="step">

		<p>See Respect Connect SDK on Github</p>

		<p><a href="https://github.com/RespectNetwork/sdk-respect-connect">https://github.com/RespectNetwork/sdk-respect-connect</a></p>

		</div>

	</div>	

	</form>

</body>

</html>
