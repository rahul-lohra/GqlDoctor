class Result{

}
class Success<T> extends Result{
  T data;
  Success(T data){this.data = data;}
}
class Fail extends Result{
  Exception e;
  Fail(Exception e){this.e = e;}
}
class Loading extends Result{}