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

		function clickdiscovercloudnumberfromprod() {

			xdi.discovery(

				$('#requestingparty').val(),
				function(discovery) {
					$('#requestingparty').val(discovery.cloudNumber());
					$('#xdiendpoint').val(discovery.xdiEndpoint());
				},
				function(errorText) {
					$('#requestingparty').val(errorText);
				},
				"http://mycloud.neustar.biz:12220/"
			);
		}

		function clickdiscovercloudnumberfromote() {

			xdi.discovery(

				$('#requestingparty').val(),
				function(discovery) {
					$('#requestingparty').val(discovery.cloudNumber());
					$('#xdiendpoint').val(discovery.xdiEndpoint());
				},
				function(errorText) {
					$('#requestingparty').val(errorText);
				},
				"http://mycloud-ote.neustar.biz:12220/"
			);
		}

		function clickbuildlinkcontracttemplateaddress() {

			$('#linkcontracttemplateaddress').val("{$from}" + $('#requestingparty').val() + "+registration" + "[$do]" + "!:uuid:" + xdi.util.guid());
		}

		function clickretrieveprivatekey() {

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

		function clickbuildxdi() {

			$.ajax({

				url: "BuildMessageXDI?" + $('#form').serialize(),
				type: 'post',
				success: function(data) {
					var text = JSON.stringify(data, null, "  ");
					$('#messagexdiresult').text(text);
				},
				error: function(data) {
					var text = "error: " + JSON.stringify(data, null, "  ");
					$('#messagexdiresult').text(text);
				}
			});

			$.ajax({

				url: "BuildLinkContractTemplateXDI?" + $('#form').serialize(),
				type: 'post',
				success: function(data) {
					var text = JSON.stringify(data, null, "  ");
					$('#linkcontracttemplatexdiresult').text(text);
				},
				error: function(data) {
					var text = "error: " + JSON.stringify(data, null, "  ");
					$('#linkcontracttemplatexdiresult').text(text);
				}
			});
		}

		function clickbuildmessagehtml() {

			$.ajax({

				url: "BuildMessageXDI?" + $('#form').serialize(),
				type: 'post',
				success: function(data) {
					var xdimessage = JSON.stringify(data);
					var returnurl = $('#form input[name=returnUrl]').val();
					var text = '';
					text += '<form action="http://respectconnect.respectnetwork.net/respectconnect/" method="post">\n';
					text += '<input type="image" src="http://respectconnect.respectnetwork.net/respectconnect/images/respectconnect.png">\n';
					text += '<input type="hidden" name="xdimessage" value="' + _.escape(xdimessage) + '">\n';
					text += '<input type="hidden" name="returnurl" value="' + _.escape(returnurl) + '">\n';
					text += '</form>\n';
					$('#messagehtmlresult').text(text);
				},
				error: function(data) {
					var text = "error: " + JSON.stringify(data, null, "  ");
					$('#messagehtmlresult').text(text);
				}
			});
		}

		function clickinstalllinkcontracttemplatexdi() {

		}

		function clickinstallmetalinkcontractxdi() {
		
		}

		$(document).ready(function() {

			$("#buttondiscovercloudnumberfromprod").on("click", clickdiscovercloudnumberfromprod);
			$("#buttondiscovercloudnumberfromote").on("click", clickdiscovercloudnumberfromote);
			$("#buttonbuildlinkcontracttemplateaddress").on("click", clickbuildlinkcontracttemplateaddress);
			$("#buttonretrieveprivatekey").on("click", clickretrieveprivatekey);
			$("#buttonbuildxdi").on("click", clickbuildxdi);
			$("#buttonbuildmessagehtml").on("click", clickbuildmessagehtml);
			$("#buttoninstalllinkcontracttemplatexdi").on("click", clickinstalllinkcontracttemplatexdi);
			$("#buttoninstallmetalinkcontractxdi").on("click", clickinstallmetalinkcontractxdi);
		});

	</script>

</head>

<body>

	<form id="form">

	<div id="header">

		<img id="applogo" src="images/logo.png">
		<span id="appname">Respect Connect Button Builder</span>

	</div>

	<div id="main">

	<% if (request.getAttribute("error") != null) { %>

		<p style="font-family: monospace; white-space: pre; color: red;"><%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %></p>

	<% } %>

	<h1>Step 1: Build Message XDI and Link Contract Template XDI</h1>

		<div class="step">

		<table cellspacing="0" cellpadding="5" border="0">
		<tr>
		<td>Requesting Party:</td>
		<td>
		<input type="text" name="requestingParty" id="requestingparty" size="80" value="@acmebread">
		<input type="hidden" name="xdiEndpoint" id="xdiendpoint"><br>
		<input type="button" id="buttondiscovercloudnumberfromprod" value="Discover Cloud Number from PROD">
		<input type="button" id="buttondiscovercloudnumberfromote" value="Discover Cloud Number from OTE">
		</td>
		</tr>
		<tr>
		<td>Address of Link Contract Template:</td>
		<td>
		<input type="text" name="linkContractTemplateAddress" id="linkcontracttemplateaddress" size="80"><br>
		<input type="button" id="buttonbuildlinkcontracttemplateaddress" value="Build Link Contract Template Address">
		</td>
		</tr>
		<tr>
		<td>Secret Token:</td><td><input type="text" name="secretToken" id="secrettoken" size="80" value="bestbread"></td>
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

		<p><input type="button" id="buttonbuildxdi" value="Build Message XDI and Link Contract Template XDI"></p>
	
		<div style="display: table; border-spacing: 10px;">
		<div style="display: table-row;">
		<div style="display: table-cell;" class="messagexdiheading">
			Message XDI
		</div>
		<div style="display: table-cell;" class="linkcontracttemplatexdiheading">
			Link Contract Template XDI
		</div>
		</div>
		<div style="display: table-row;">
		<div style="display: table-cell; width: 600px; max-width: 600px;" class="result">
			<div id="messagexdiresult"></div>
		</div>
		<div style="display: table-cell; width: 600px; max-width: 600px;" class="result">
			<div id="linkcontracttemplatexdiresult"></div>
		</div>
		</div>
		</div>

		</div>

	<h1>Step 2: Install Message HTML on your website</h1>

		<div class="step">

		<table cellspacing="0" cellpadding="5" border="0">
		<tr>
		<td>Return URL:</td><td><input type="text" name="returnUrl" size="80" value="https://yourwebsite.com/returnurl.html"></td>
		</tr>
		</table>

		<p><input type="button" id="buttonbuildmessagehtml" value="Build Message HTML"></p>
	
		<div style="display: table; border-spacing: 10px;">
		<div style="display: table-row;">
		<div style="display: table-cell;" class="messagehtmlheading">
			Message HTML
		</div>
		</div>
		<div style="display: table-row;">
		<div style="display: table-cell; width: 1200px; max-width: 1200px;" class="result">
			<div id="messagehtmlresult"></div>
		</div>
		</div>
		</div>
	
		</div>

	<h1>Step 3: Install Link Contract Template XDI in your Cloud</h1>

		<div class="step">
		
		<table cellspacing="0" cellpadding="5" border="0">
		<tr>
		<td>Secret Token:</td><td><input type="text" name="secretToken" size="80"></td>
		</tr>
		</table>

		<p><input type="button" id="buttoninstalllinkcontracttemplatexdi" value="Install Link Contract Template XDI"></p>
		
		</div>
	
	<h1>Step 4: Install Meta Link Contract XDI in your Cloud</h1>

		<div class="step">
		
		<table cellspacing="0" cellpadding="5" border="0">
		<tr>
		<td>Secret Token:</td><td><input type="text" name="secretToken" size="80"></td>
		</tr>
		</table>
		
		<p><input type="button" id="buttoninstallmetalinkcontractxdi" value="Install Meta Link Contract XDI"></p>
		
		</div>
	
	<h1>Step 5: Install and integrate the Respect Connect SDK with your Website</h1>

		<div class="step">

		<p>See Respect Connect SDK on Github</p>
		
		<p><a href="https://github.com/RespectNetwork/sdk-respect-connect">https://github.com/RespectNetwork/sdk-respect-connect</a></p>
		
		</div>

	</div>	

	</form>

</body>

</html>
