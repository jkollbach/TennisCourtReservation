<?php

class Account
{
	function startSession()
	{
		$_SESSION['username'] = $this->user;
	}

	function hasSession()
	{
		session_start();
		if (isset($_SESSION['username']))
		{
			$this->user = $_SESSION['username'];
			return true;
		}
		return false;
	}

	function loadData($username)
	{
		$this->data = db_GetUserData($username);
		$atPos = strpos($this->data['emailAddress'],"@");
		if ($atPos > 0)
		{
			$account = substr($this->data['emailAddress'],0,$atPos);
		}
		$this->account = $account;
		$this->user = $this->data['emailAddress'];
	}

	function getUsername()
	{
		return $this->user;
	}

	function getUserID()
	{
		return $this->data['pkid'];
	}
		
	function auth($pass)
	{
		if (password_verify($pass, $this->data['pwhash']))
		{
			return true;
		}
		return false;
	}

	function isLoggedIn()
	{
		if (isset($_SESSION['loggedin']) && $_SESSION['loggedin'] == true && isset($_SESSION['ua']) && $_SESSION['ua'] == $_SERVER['HTTP_USER_AGENT'])
		{
			return true;
		}
		return false;
	}

	function isOTP()
	{
		if (isset($_SESSION['OTP']) && $_SESSION['OTP'] == true)
		{
			return true;
		}
		return false;
	}

	function doLogin()
	{
		session_regenerate_id();
		$_SESSION['loggedin'] = true;
		$_SESSION['ua'] = $_SERVER['HTTP_USER_AGENT'];
	}
}
?>
