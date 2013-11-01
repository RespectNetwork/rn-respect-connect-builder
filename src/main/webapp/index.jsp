<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>

<head>

	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Respect Connect Button Builder</title>
	<link rel="stylesheet" target="_blank" href="style.css" TYPE="text/css" MEDIA="screen">
	<script type="text/javascript" src="jquery-2.0.3.min.js"></script>
	<script type="text/javascript" src="lodash.compat.min.js"></script>

	<script type="text/javascript">

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

		$(document).ready(function() {
	
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
		<td>Requesting Party:</td><td><input type="text" name="requestingParty" size="80" value="[@]!:uuid:e0178407-b7b6-43f9-e017-8407b7b643f9"></td>
		</tr>
		<tr>
		<td>Private Key for Signature:</td><td><textarea name="privateKey" cols="50" rows="3">MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQCqrkJswChCygqqOpjeEtYZ7GEEXwcVCAFu1D30qfk3eo7yVWRtCzYMMQGxbvkZ05aTqBtkqpOOE0O0u7uib36pw3TRl8vQPfBjXYvI/sy4TQv8HuAQopsjrawOlU04vdt+bfh6BR/7f1bJcUv3+Okh9fEoAQzzNWqcM8X+cvLGRt1Vv5u4DOFEa5lsK5/E50DKQBU+QW9P/+RZaw0bdC/H1xf9EcaGhsmpwKIW+TLBKLRwDeFhUXt7ILzrZawmytDTZ/Nfb/t0R5gKncyhxeeamFe2gebDOjLh7bhLdbSbBqe4dQX2NUe9QG4dQf4jy22V8Y2zjlJEyfn0pELurAn9AgMBAAECggEBAIfmVHFu1x/G65L7MTixWtQtSFpIp8TxKOLsD6C9rfekmCkQIPRKFvDCHI0AxUrxFFXhZl5TC0X2xNQlHpOJnxrgzCUObnQSvVMA6wpRBwRAJKjMlK/qKQjRgcviySfC0//o5A2UAxEnJR0kHs8E2+v0fd3SaFNGVuqktqORNwjzmgKBOqWk2uhbThWBqJEYdeqljFOGobiDugHBWfGEHNQIG7YEqKzMz/5Q6NVkPNQtDgBa4+21tyLEJ49wO8FG/Sxjq6y+5mY13SQ0fM617q8x1IbW2kzGu3P63CXwUw1izGEvnLjRU7wIjS2eLPGWMsUCGNGV/C72cU8ID0JVZKkCgYEA4Rdm57JOoDaJ2WfDnth2ED57ou7awY8h4rryiviqGo3RTAVcF5FJBY4k4ZpyG230PyrHEhhB6lxCkvEc+jo+yYqgK1KmppfZAQ2jcl8/PTWkVwirF8YQM3Kb9DayxDbM83kEzGmXrKEcMuMhJ/3BWVPwQOT8IZ4KBBkow6kjnX8CgYEAwh4q4FuUUNNfefn8xRtqgzwHhm3Nnj6+4/hjq2ZuhvbnvpLpQDv8qSi47TULG6PjVUl4wB0G8q1UOliEgwQhhN5lhpBZqFqo4Alrz7iUALkTvESPt2Sxd+aZngHhmJjJu5tTd4I+i92R+HT0CHR1p3Lfm2u0CrvfIZTUpVbqjoMCgYEAsodpKyQVkKUxOKpAUeDF46RrU5O3FgZ8jeRRM0B/SohpFK67mEW3cRyIzBc/odnX+7HmKsfqoAOFGh77KMzBuACngTUQ0NlnWJqEpNY+xkGhkxZg/X4uo1+nqk8oAtCkRggacjbeAiHWx9W2Go39qOgWiqIUCGXc89swpd+lS+kCgYB4t7IKXGlb6ldRz7j2CxquCkLTwq1AX9zugKXbDZRmsl1kEpCjtapmuEBoo7gItF7Hxy0kq+iKOmhK8IlXwNXnfza7/EEFhXvH95PoVe0UlgRD7I9DiYcj/XBC5wCYmUu7M9kwVPr4mA4S6QhpyaLxQ2rziIMqubMFezzSpb6waQKBgQC/AmYnjmeToGgGigYfX6g4L5qjs4+7fPSxDpWHWDTMqP8bDlxW2QFY/OkesbU177OaoayC3TIT+GOx/h15lbbCgJcGo1o7iWK5W4YXvbE4DpHfX/BQvMsTCEbuMVHcrOMvRlDiA52P3LHiq4N/Ky2lBqw2pg5kANDvZonmbxElmQ==</textarea></td>
		</tr>
		<tr>
		<td>Address of Link Contract Template:</td><td><input type="text" name="linkContractTemplateAddress" size="80" value="{$from}[@]!:uuid:e0178407-b7b6-43f9-e017-8407b7b643f9+registration$do"></td>
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
