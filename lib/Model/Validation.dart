enum TYPE { TEXT,EMAIL,PASSWORD }

class Validation{


  RegExp EMAIL_REGEX = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  String isRequired(String val, String fieldName) {
    if (val == null || val == '') {
      return "$fieldName is required";
    }
    return null;
  }

  String CheckPasswordLength(String val) {
    if (val.length < 6) {
      return 'Password must be 6 digit';
    }
    return null;
  }


  validate(String fieldName,String value,TYPE type){
    String errorMsg;
    if(type == TYPE.TEXT){
      errorMsg = isRequired(value, fieldName);
    }else if(type == TYPE.EMAIL){
      if (isRequired(value, fieldName) != null) {
        errorMsg = isRequired(value, fieldName);
      } else if (!EMAIL_REGEX.hasMatch(value)) {
        errorMsg = "Please enter valid email";
      }
    }else if(type == TYPE.PASSWORD){
      errorMsg = isRequired(value, fieldName);
    }
    return (errorMsg != null) ? errorMsg : null;
  }
}