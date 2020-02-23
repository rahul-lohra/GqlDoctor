class Result {}

class Success<T> extends Result {
  T data;

  Success(T data) {
    this.data = data;
  }
}

class Fail extends Result {
  Exception exception;
  Error error;

  Fail(dynamic item) {
    if (item is Error) {
      this.error = item;
    } else if (item is Exception) {
      this.exception = item;
    }
  }

  String getMessage(){
    if(exception!=null){
      return exception.toString();
    }else if (error!=null){
      return error.toString();
    }else{
      return "Unknnow Error";
    }
  }
}

class Loading extends Result {}
