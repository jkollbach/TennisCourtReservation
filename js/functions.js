Date.prototype.addHours = function(h)
{ 
	this.setTime(this.getTime() + (h * 60 * 60 * 1000)); 
	return this; 
}

function userLogout()
{
	var addr = window.location.href;
	var i = addr.indexOf("?");
	if (i > 0)
	{
		addr = addr.substring(0,i);
	}
	addr += "?logout=1";
	window.location.href = addr;
}

function passwordStrength(pw)
{
	return /.{8,}/.test(pw) * (  /* at least 8 characters */
		/.{12,}/.test(pw)          /* bonus if longer */
		+ /[a-z]/.test(pw)         /* a lower letter */
		+ /[A-Z]/.test(pw)         /* a upper letter */
		+ /\d/.test(pw)            /* a digit */
		+ /[^A-Za-z0-9]/.test(pw)  /* a special character */
	)
}

// Update the clock
function updateClock()
{
	var currentTime = new Date();

	var currentHours = currentTime.getHours();
	var currentMinutes = currentTime.getMinutes();
	var currentSeconds = currentTime.getSeconds();

	currentMinutes = ( currentMinutes < 10 ? "0" : "" ) + currentMinutes;
	currentSeconds = ( currentSeconds < 10 ? "0" : "" ) + currentSeconds;

	var currentTimeString = currentHours + ":" + currentMinutes + ":" + currentSeconds + " ";

	document.getElementById("clock").firstChild.nodeValue = currentTimeString;
}

// Display a specific DIV identified by ID
function showScreen(iScr)
{
	if (iScr > 0)
	{
		switch (iScr)
		{
			case 1:
				document.getElementById('idWarningForm').style.display = "block";
				break;
			case 2:
				document.getElementById('changePw').style.display = "block";
				break;
			case 3:
				document.getElementById('idLgnForm').style.display = "block";
				break;
			case 5:
				document.getElementById('idPlayerManage').style.display = 'block';
				break;
			case 10:
				document.getElementById('idNotActiveForm').style.display = 'block';
				break;
			default:
				break;
		}
	}
}


// Display the Password-Change DIV
function openPWTab()
{
	document.getElementById('changePw').style.display = "block";
}

// Display the Court Tabs (DIV)
function openTab(evt, tabName)
{
	var i, tabcontent, tablinks;
	tabcontent = document.getElementsByClassName("tabcontent");
	for (i = 0; i < tabcontent.length; i++)
	{
		tabcontent[i].style.display = "none";
	}
	tablinks = document.getElementsByClassName('tablinks');
	for (i = 0; i < tablinks.length; i++)
	{
		tablinks[i].className = tablinks[i].className.replace(" active", "");
	}
	document.getElementById(tabName).style.display = "block";
	if (evt.type != "click")
	{
		tablinks[0].className += " active"; 
	} else
	{
		evt.currentTarget.className += " active";
	}
}


function resBooking(jsData)
{
	const queryString = window.location.search;
	var bLoggedIn = jsData["loggedIn"];
	var bLocalConnected = jsData["localConnected"];

	var urlParams = new URLSearchParams(queryString);
	var rMethod = urlParams.get('rMethod');
	var rDate = urlParams.get('rDate');
	var rHour = urlParams.get('rHour');
	var rCourt = urlParams.get('rCourt');

	var iPerDay = jsData["perDay"];
	var iPerWeek = jsData["perWeek"];
	var iMaxDay = jsData["maxDay"];
	var iMaxWeek = jsData["maxWeek"];
	var jsDataStr = JSON.stringify(jsData);
	document.getElementById('tabjsonData').value = jsDataStr;

	if ((iPerDay < iMaxDay) && (iPerWeek < iMaxWeek))
	{
		var props = "rMethod=b&rDate=" + jsData["rDate"] + "&rHour=" + jsData["rHour"] + "&";
		if (jsData["loggedIn"])
		{
			document.getElementById('idPlayerForm').style.display = 'block';
		} else
		{
			document.getElementById('idLgnForm').style.display = 'block';
		}
	} else
	{
			document.getElementById('idWarningForm').style.display = 'block';
	}
}

function resManage(userid,bkid,rStatus,jsData,iMin)
{
	const dateParts = jsData["rDate"].split('-');
	const aPlayers = jsData["Players"].split(';');
	var strPlayers = aPlayers.join(' / ');
	var now = Date.now() / 1000 | 0;
	var jsDataStr = JSON.stringify(jsData);
	var bLocalConnected = jsData["localConnected"];
	var bCheckInMethod = jsData["CheckInMethod"];
	var iMin = jsData["CheckInMinutes"];
	var bookDate = jsData['unixts'];
	var diffSec = (bookDate - now);
	var maxSec = iMin * 60;

	if (jsData["loggedIn"])
	{
		if (rStatus > 0)
		{
			var strMyDate = dateParts[2] + "." + dateParts[1] + "." + dateParts[0];
			document.getElementById("TMySchedule").firstChild.nodeValue = strMyDate;
			document.getElementById("TMyTime").firstChild.nodeValue = jsData["rHour"] + ":00 " + jsData["strTime"];
			document.getElementById("TMyCourt").firstChild.nodeValue = jsData["strCourt"];
			document.getElementById("TMyPlayers").firstChild.nodeValue = strPlayers;
			document.getElementById('reservationid').value = bkid;

			if ((rStatus == 5) && (bLocalConnected) && (diffSec <= maxSec) && (bCheckInMethod))
			{
				document.getElementById('idConfirmBooking').style.display = 'inline';
			} else
			{
				document.getElementById('idConfirmBooking').style.display = 'none';
			}
			if (jsData["userid"] == jsData['Requester'])
			{
				document.getElementById('idCancelBooking').style.display = 'inline';
			} else
			{
				document.getElementById('idCancelBooking').style.display = 'none';
			}
			document.getElementById('idPlayerManage').style.display = 'block';
		}
	} else
	{
		document.getElementById('idLgnForm').style.display = 'block';
	}
}

function updateSelPlayer3 (jsData,strDefault,myId)
{
	var eselected = document.getElementById('selPlayer2').value;
	let dropdown = document.getElementById('selPlayer3');
	dropdown.length = 0;
	let defaultOption = document.createElement('option');
	defaultOption.text = strDefault;
	defaultOption.value = "0";
	dropdown.add(defaultOption);
	dropdown.selectedIndex = 0;
	let option;
	for (let i = 0; i < jsData.length; i++)
	{
		if ((myId != jsData[i].pkid) && (jsData[i].pkid != eselected))
		{
			option = document.createElement('option');
			option.text = jsData[i].lastName + ", " + jsData[i].firstName;
			option.value = jsData[i].pkid;
			dropdown.add(option);
		}
	}
}

function updateSelPlayer4 (jsData,strDefault,myId)
{
	var eselected1 = document.getElementById('selPlayer2').value;
	var eselected2 = document.getElementById('selPlayer3').value;
	let dropdown = document.getElementById('selPlayer4');
	dropdown.length = 0;
	let defaultOption = document.createElement('option');
	defaultOption.text = strDefault;
	defaultOption.value = "0"
	dropdown.add(defaultOption);
	dropdown.selectedIndex = 0;
	let option;
	for (let i = 0; i < jsData.length; i++)
	{
		if ((myId != jsData[i].pkid) && (jsData[i].pkid != eselected1) && (jsData[i].pkid != eselected2))
		{
			option = document.createElement('option');
			option.text = jsData[i].lastName + ", " + jsData[i].firstName;
			option.value = jsData[i].pkid;
			dropdown.add(option);
		}
	}
}

function bookCourt()
{
	const url = window.location.href;
	var jsDataStr = document.getElementById('tabjsonData').value;
	var jsData = JSON.parse(jsDataStr);
	var player2 = document.getElementById('selPlayer2').value;
	var player3 = document.getElementById('selPlayer3').value;
	var player4 = document.getElementById('selPlayer4').value;
	jsData['aMembers'].push(player2);
	if (parseInt(player3) != 0)
	{
		jsData['aMembers'].push(player3);
	}
	if (parseInt(player4) != 0)
	{
		jsData['aMembers'].push(player4);
	}
	jsData.step = 1;
	jsDataStr = JSON.stringify(jsData);
	document.getElementById('tabjsonData').value = jsDataStr;
	document.getElementById('idPlayerForm').submit();
}

function manageCourt(iVal)
{
	document.getElementById('manageMethodid').value = iVal;
	document.getElementById('idManageForm').submit();
}

function changePWField()
{
	var checkPW = document.getElementById('resetPW').checked;
	if (checkPW)
	{
		document.getElementById("idPassword").required = false;
	} else
	{
		document.getElementById("idPassword").required = true;
	}
}
