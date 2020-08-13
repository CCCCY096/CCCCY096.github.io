## About Golang

*没想到我现在连编程语言都能云*🤔


### Interface

An *interface type* is defined as a set of method signatures.	

Under the hood, interface values can be thought of as **a tuple of a value and a concrete type**.  
After line 14, the interface value `student` can be seen as `(chen, Chinese)` :

```go
type person interface { // An interface that defines what a person does
	speak() string
    getMathScore() int
}
type Chinese struct { // A struct that defines a race
	nativeLang string
	mathScore int
}
int main() {
    var student person
    chen Chinese
    student = Chinese // A Chinese called Chen implements this student   
    fmt.Printf("Chen speaks %s and his math score is %d", chen.speak(), chen.getMathScore())
}
// Skipped codes that implements func (a *Chinese) speak() string and the others
// Spoiler alert: output is "Chen speaks trash and his math score is 59."👌😎👍
```

An *empty interface* may hold values of any type!

```go
func Println(a ...interface{}) (n int, err error) // This thing holds any number and type of values. Damn!
```

### Closure

`func` is also a first class citizen in Golang, and therefore `closure` is supported.

### Template

Golang doesn't support template officially. There are some third-party package, however, can create the illusion of template. 

**Just in! Golang's update on generics**: [https://blog.golang.org/generics-next-step](https://blog.golang.org/generics-next-step)

> ... the earliest that generics could be added to Go would be the Go 1.17 release, scheduled for August 2021.

And this is yet a optimistic prediction!

Below are some quick overview of the generic feature:

* Function with type parameter list: `func F(type T1, type T2) (p T) { ... }`
* Each type parameter can have an optional type constraint: `func F(type T Constraint)(p T) { ... }`
* Types can also have a type parameter list: `type M(type T) []T`

### Coroutine

*Coroutine* is like `thread` in user mode. Kernel doesn't know the existence of coroutines; It is the runtime (like in Golang) or generator (like in python) or something else that schedules them.

`Goroutine` is scheduled by Golang runtime using resizable, bounded stacks . It switch a `Goroutine` when it blocks (during a blocking sys call for example). 

`Goroutine` is cheap. A few KB each in size typically. CPU overheads are also small.

`Goroutine`'s context switching is fast. It involves only a few registers, whereas `thread`'s context switching involves more reigisters and some mode changing (user mode / kernel mode).

`Goroutine` avoid blocking as much as possible. 