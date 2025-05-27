import 'package:flutter/material.dart';

const mainColor  = Color(0xffFFE3AF);
const buttonColor  = Color(0xffD9D9D9);
const darkOrange  = Color(0xffFC6E2A);
const deepRed  = Color(0xff591712);
const kBrown  = Color(0xffC29500);
const blueHawai  = Color(0xff63B4FF);
const brownDark  = Color(0xffA24D19);

const baseFont = 'GE Dinar One';



class APIConstant {
  static const BASE_URL = "https://khedr.erpai-eg.com";
  static const REGISTRER_USER = "$BASE_URL/api/user/register";
  static const  LOGIN_USER = "$BASE_URL/api/login";
  static const GET_ALL_PRODUCTS = "$BASE_URL/api/products";
  static const GET_ALL_PRODUCTS_BY_CATEGORY = "$BASE_URL/api/category/products";
  static const GET_TOP_RATED_ITEMS = "$BASE_URL/api/products/totalSold";
  static const GET_BANNERS = "$BASE_URL/api/banners";
  // static final GET_ALL_SUBCATEGORY = "$BASE_URL/api/category/subcategories/";
}
