(*
 * expr.ml
 * cse130
 * based on code by Chris Stone
 *)

type expr = 
    VarX
  | VarY
  | Sine     of expr
  | Cosine   of expr
  | Average  of expr * expr
  | Times    of expr * expr
  | Thresh   of expr * expr * expr * expr	
  | Max 	 of expr * expr
  | Cubic    of expr * expr * expr

(* exprToString : expr -> string
   Complete this function to convert an expr to a string 
*)
let rec exprToString e = 
	match e with 
	|VarX -> "x"
	|VarY -> "y"
	|Cosine e -> "cos(pi*" ^ (exprToString e) ^ ")"
	|Sine e -> "sin(pi*" ^ (exprToString e) ^ ")"
	|Average (e1,e2) -> "((" ^ (exprToString e1) ^ "+" ^ (exprToString e2) ^ ")/2)"
	|Times (e1,e2) -> (exprToString e1) ^ "*" ^ (exprToString e2)
	|Max(e1,e2) -> "(" ^(exprToString e1)^ " >= " ^ (exprToString e2)  ^ "?" ^ (exprToString e1) ^  " :" ^ (exprToString e2) ^ ")" (*e1>=e2?e1:e2*)
	|Cubic(e1,e2,e3) -> "(cos(pi*" ^ (exprToString e1) ^ ") + sin(pi*" ^ (exprToString e2) ^ ") ) * " ^ "cos(pi*" ^(exprToString e3) ^")"
	|Thresh (e1,e2,e3,e4) -> (exprToString e1) ^ "*" ^ (exprToString e2) ^ "*" ^ (exprToString e3) 

(* build functions:
     Use these helper functions to generate elements of the expr
     datatype rather than using the constructors directly.  This
     provides a little more modularity in the design of your program *)

let buildX()                       = VarX
let buildY()                       = VarY
let buildSine(e)                   = Sine(e)
let buildCosine(e)                 = Cosine(e)
let buildAverage(e1,e2)            = Average(e1,e2)
let buildTimes(e1,e2)              = Times(e1,e2)
let buildThresh(a,b,a_less,b_less) = Thresh(a,b,a_less,b_less)
let buildMax(e1,e2) 			   = Max(e1,e2)
let buildCubic(e1,e2,e3)		   = Cubic(e1,e2,e3)


let pi = 4.0 *. atan 1.0

(* eval : expr -> real*real -> real
   Evaluator for expressions in x and y *)

let rec eval (e,x,y) = 	
		match e with 
		|VarX -> x
		|VarY -> y
		|Cosine e -> cos(pi*.(eval (e, x, y)))
		|Sine e -> sin(pi*.(eval (e,x,y)))
		|Average (e1,e2) -> (((eval (e1,x,y))+.(eval (e2,x,y))) /. (2.0))
		|Times (e1,e2) -> (eval(e1,x,y)) *. (eval (e2,x,y))
		|Thresh (e1,e2,e3,e4) -> (if (eval (e1,x,y)) < (eval (e2,x,y)) then (eval (e3,x,y)) else (eval (e4,x,y)))
		|Max(e1,e2) -> (if (eval (e1,x,y)) >= (eval (e2,x,y)) then (eval (e1,x,y)) else (eval (e2,x,y)))
		|Cubic(e1,e2,e3) -> eval(e1,x,y) *. eval(e2,x,y) *. eval(e3,x,y)

let eval_fn e (x,y) = 
  let rv = eval (e,x,y) in
  assert (-1.0 <= rv && rv <= 1.0);
  rv



let sampleExpr =
      buildCosine(buildSine(buildTimes(buildCosine(buildAverage(buildCosine(
      buildX()),buildTimes(buildCosine (buildCosine (buildAverage
      (buildTimes (buildY(),buildY()),buildCosine (buildX())))),
      buildCosine (buildTimes (buildSine (buildCosine
      (buildY())),buildAverage (buildSine (buildX()), buildTimes
      (buildX(),buildX()))))))),buildY())))

let sampleExpr2 =
  buildThresh(buildX(),buildY(),buildSine(buildX()),buildCosine(buildY()))


(************** Add Testing Code Here ***************)
