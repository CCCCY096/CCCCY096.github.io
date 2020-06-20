# Future blogs are born here! (maybe)

*Disclaimer: these notes tend to have errors as I am still a noob at coding.*

## <u>About Golang</u>

### Interface

An *interface type* is defined as a set of method signatures.

Under the hood, interface values can be thought of as **a tuple of a value and a concrete type**.  
After line 14, the interface value `student` can be seen as `(chen, Chinese)` :

```go
type person interface { // An interface that defines what a person does
	speak() string
	getMathScore int
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
// Here are codes that implements func (a *Chinese) speak() string and others
// Spoiler alert: output is "Chen speaks trash and his math score is 59.👌😎👍"
```

An *empty interface* may hold values of any type. Therefore it can hold values of any type!

```go
func Println(a ...interface{}) (n int, err error) // This thing holds any number and type of values. Damn!
```

### Closure

`func` is also a first class citizen in Golang, and therefore `closure` is supported.

### Template

Golang doesn't support template officially. There are some third-party package, however, can create the illusion of template. 

### Coroutine

*Coroutine* is like `thread` in user mode. Kernel doesn't know the existence of coroutines; It is the runtime (like in Golang) or generator (like in python) or something else that schedules them.

`Goroutine` is scheduled by Golang runtime using resizable, bounded stacks . It switch a `Goroutine` when it blocks (during a blocking sys call for example). 

`Goroutine` is cheap. A few KB each in size typically. CPU overheads are also small.
