# Git指引

## 写在前面

本指引的主要内容：

1. Git特性和基础概念
2. Git底层实现（重点）
3. Git经典工作流程及其原理（基本操作，分支操作，远程仓库交互等等）
4. 附加内容：
   * 断头状态（detached HEAD）
   * `git checkout`王朝的瓦解？论新王`git switch`和`git restore`如何瓜分其领土
   * 子模块（submodule） 

**最后请注意：我提到的操作往往有更多的功能未列出（Git真的太全能了)，如果想了解更多请搜索相应文档。**

内容挺长的，善用`ctrl + f` :)

欢迎修正、补充！(づ￣ 3￣)づ

[toc]

---

## Git的重要特性介绍与对比

### 分布式版本控制系统
每一次git clone都是对代码仓库 (repository)的完整备份，包含了所有的历史commits。

相对的，集中式版本控制系统的SVN，其`svn checkout`仅下载一次commit的信息。

既然本地代码仓库包含了所有的历史信息，那么Git的几乎所有操作都是本地的，提高了速度。

### 直接记录快照，而非差异比较
Git的commit是对所有文件的一次***快照***（snapshot）。

![Git 存储项目随时间改变的快照。](https://git-scm.com/book/en/v2/images/snapshots.png)

相对的，SVN的commit记录的是所有文件相较于上次commit的***差异***（delta）。

![存储每个文件与初始版本的差异。](https://git-scm.com/book/en/v2/images/deltas.png)



Git的***快照流***使得Git在`branch`和`merge`上有无与伦比的优势。这个接下来会介绍。

也许有人会担心存储***快照***而不是***差异***会让代码仓库膨胀，但其实Git有特殊的优化姿势（比如garbage collection），不用担心仓库过大。

### Git一般只添加数据
这意味着Git的几乎所有操作都是可逆的，浪子回头真的很容易。



---

## Git的基础概念

### 一个Git项目的分区

一个Git项目会有3个分区：工作区（working directory），暂存区（staging area），Git仓库（Git directory）。

> 工作区是对项目的某个版本独立提取出来的内容。 这些从 Git 仓库的压缩数据库中提取出来的文件，放在磁盘上供你使用或修改。

> 暂存区是一个文件，保存了下次将要提交的文件列表信息，一般在 Git 仓库目录中。 按照 Git 的术语叫做“索引”，不过一般说法还是叫“暂存区”。

>Git 仓库目录是 Git 用来保存项目的元数据和对象数据库的地方。 这是 Git 中最重要的部分，从其它计算机克隆仓库时，复制的就是这里的数据。

### Git项目中文件的状态

被Git追踪（tracked）的文件，有以下几种状态：

***已修改***（modified）：表示修改了***工作区***中的文件，但还没保存到***Git仓库***中。

***已暂存***（staged）：表示该文件已被加入***暂存区***，会被加入到下次commit的快照中。

***已提交***（committed）：文件已经被安全地保存在***Git仓库***中。

不被追踪（untracked）的文件会被Git无视掉。可以用`git add ...`来追踪它。

### 结合以上两个知识点...

基本的 Git 工作流程如下：

1. 在***工作区***中修改文件。这些文件变成***已修改***（modified）。
2. 通过`git add ...`将你想要下次提交的更改选择性地暂存，这样只会将更改的部分添加到***暂存区***。这些文件变成***已暂存***（staged）。
3. 通过`git commit ...`提交更新，找到***暂存区***的文件，将快照永久性存储到 ***Git 仓库***。这些文件变成***已提交***（committed）。

*图示：数据如何在三个工作区流通*

![工作区、暂存区以及 Git 目录。](https://git-scm.com/book/en/v2/images/areas.png)

*图示：文件状态如何转变（此处的add，remove是指`git add`和`git remove`，而不是`rm`等UNIX指令）*

![Git 下文件生命周期图。](https://git-scm.com/book/en/v2/images/lifecycle.png)



---

## Git的底层结构（重要）

### Git的核心

Git的核心是一个简单的key-value数据库，存在于`.git/`里。

这个数据库的key是校验和，一个SHA-1生成的长度为40的hash value；value是hash object（分为数据对象，树对象或者提交对象），这些object存在`.git/objects/`里。

***数据对象***（blob object）：存储一个文件的内容

***树对象***（tree object）：指向一些子tree object或者blob object，并且存储相应的元数据。一次快照就是一个tree objects和blob objects的组合。

***提交对象***（commit object）：记录了何时、何地、为何保存了这次快照。

*图示：一个树对象指向3个存储有3个文件内容的数据对象，组成了一个快照，而一个提交对象记录了这个快照的元数据。*

![首次提交对象及其树结构。](https://git-scm.com/book/en/v2/images/commit-and-tree.png)

### Git的提交历史

一个提交对象指向另一个提交对象，就这样组成了提交的历史。

*图示：快照C的父亲是快照B，快照B的父亲是快照A。*

![提交对象及其父对象。](https://git-scm.com/book/en/v2/images/commits-and-parents.png)

### Git的分支

Git 的分支，其实本质上仅仅是指向提交对象的可变指针，指向该分支的头（最新commit）。Git 的默认分支名字是 `master`。

Git有一个名为 `HEAD` 的特殊指针，它正常指向当前的分支指针（随着该分支指针间接指向该分支的头），或者直接指向一个具体的commit（导致`detached HEAD`状态）。

建立分支就是创建一个指针，切换分支就是移动指针——Git在此方面的优越性尽显无疑。

*图示：我们有两个分支`v1.0`和`master`。当前我们在`master`分支上（因为`HEAD`指向`master`）。*

![分支及其提交历史。](https://git-scm.com/book/en/v2/images/branch-and-history.png)



---

## 基本操作

*以下操作仅`git clone`不是本地操作。*

### 1. 克隆仓库到本地：`git clone <url>`

没什么好说的，但是值得一提的是`git clone`到底做了什么：

1. 从remote repo复制`.git/`这个文件夹到本地。
2. 为所有分支创立远程追踪分支（remote tracking branch）。
3. 检出（`git checkout`）master。

### 2. 将修改过或者未被追踪（如新增）的文件加入暂存区：`git add <filename>`

### 3. 删除一个文件并且不再追踪它：`git remove <filename>`

### 4. 提交暂存区的快照：`git commit`

`-m`：和`svn ci`中的`-m`效果相同

`-a`：将所有文件加入暂存区并且提交。免去了加入暂存区的操作，有时候挺方便。

`--amend`：这个挺常用。如果上次的提交的信息写错了，或者少加了一个文件到快照中，使用此指令可以根据当前的暂存区进行一次新的提交并且覆盖上一次提交。

### 5. 查看log：`git log`

git log功能强大，[如果想了解更多](https://git-scm.com/book/zh/v2/Git-%E5%9F%BA%E7%A1%80-%E6%9F%A5%E7%9C%8B%E6%8F%90%E4%BA%A4%E5%8E%86%E5%8F%B2)

### 6. 查看三个区的状态：`git status`



---

## 本地分支操作

*以下全是本地操作。*

### 1. 创建分支

本质是创建一个含有分支信息的指针，指向`HEAD`指向的commit。

`git branch <name>`

`git switch -c <name>`会创建分支并且切换过去。

`git checkout -b <name>`会创建分支并且切换过去。

### 2. 合并分支

`git merge <name>`

分两种情况：

1. 如果想要吸收的分支是当前分支的子节点，那么Git会将当前分支的指针***快进***（fast-forward）到该子节点。不会有新的提交产生。效率！

2. 如果不是上述情况，那么会进行三方合并（当前分支指向的commit，吸收的分支指向的commit，公共祖先commit）。我们会进行一次***合并提交***，它的特殊之处是该commit会有两个父节点。

   *如图：指向C4的`master`合并了指向C5的`iss53`，提交了C6。master现在指向C6。*

   ![一个合并提交。](https://git-scm.com/book/en/v2/images/basic-merging-2.png)

### 3. 删除分支

`git branch -d <name>`

### 4. 解决冲突

有时候合并会产生冲突，可用`git status`查看。

### 5. 切换分支

#### `git switch <name>`

#### `git checkout <name>`

`git switch`是2.23版本引入的新指令，存在的意义是取代`git checkout`的切换分支功能。`git checkout`功能太多，对用户不友好。

用`git checkout`来切换分支其实很合理：切换分支就是检出另一个分支上的快照而已。

***值得注意的是***：

> 但是，在你这么做之前，要留意你的工作目录和暂存区里那些还没有被提交的修改， 它可能会和你即将检出的分支产生冲突从而阻止 Git 切换到该分支。

这个限制也很合理：`git checkout`是安全的操作，它不会覆盖你的修改。想要优雅的避免冲突出现，建议`git stash`或者`git clean`（不安全）。

### 6. 变基（rebase）

除了合并（merge），整合修改的方式还可以是变基。

好处：不会产生三方合并，减少log分叉，让log看起来更整洁。

注意：**如果提交存在于你的仓库之外，而别人可能基于这些提交进行开发，那么不要执行变基。**

举例：

```bash
// 如图，将C4之于C2的改动施加（重放）到了C3上。接下来可以通过快进（fast-forward）来吸收experiment这个分支，再删除它。
git checkout experiment
git rebase master
```



![将 `C4` 中的修改变基到 `C3` 上。](https://git-scm.com/book/en/v2/images/basic-rebase-3.png)

还可以使用`--onto`来讲C4之于C2的改动重放到其他的分支上。



---

## 和远程仓库（remote repo）交互

*以下全是远程操作。*

首先是几个概念：

1. **远程分支（remote branch）**。顾名思义，远程仓库上面的分支。经常和本地仓库的分支一一对应。我们经常做的`git push`和`git pull`的目的就是同步一一对应的远程与本地分支。

2. **远程引用（remote reference）**。远程引用是对远程仓库的引用（指针），包括分支、标签等等。这些引用存在本地仓库。

3. **远程跟踪 分支（remote-tracking branch）**。它是一个远程引用（remote reference），记录了远程分支（remote branch）的状态（即上次和远程仓库同步的那一刻的状态）。注意短句：此分支跟踪（track）了远程的分支。这个引用是本地的，像一个书签一样，不可以由我们移动（它会在与远程仓库同步时自动更新）。

4. **跟踪分支（tracking branch）**。从一个远程跟踪分支检出一个本地分支会自动创建所谓的“跟踪分支”（它跟踪的分支叫做“上游分支，upstream”）。 跟踪分支是与远程分支有直接关系的本地分支。 如果在一个跟踪分支上输入 `git pull`，Git 能自动地识别去哪个服务器上抓取、合并到哪个分支。

   

懂了这些概念，接下来的操作就很容易理解了:

### 1. 拉取数据

##### 选择一：`git fetch`

与给定的远程仓库同步数据。比如`git fetch origin`。

它只拉取数据，不做其他任何操作。如果想要应用这些数据，需要手动进行`git merge`等操作。

*如下图：`git fetch`拉取了git.ourcompany.com的最新数据，更新了远程追踪分支。现在本地仓库这里有了两个分叉开来的分支，origin/master这个远程跟踪分支，以及master这个跟踪分支（假设master之前是从origin/master检出的）。接下来的操作任君处理，比如可以`git merge`来进行一个三方合并。*

![`git fetch` 更新你的远程仓库引用。](https://git-scm.com/book/en/v2/images/remote-branches-3.png)

> “origin” 并无特殊含义
>
> 远程仓库名字 “origin” 与分支名字 “master” 一样，在 Git 中并没有任何特别的含义一样。 同时 “master” 是当你运行 `git init` 时默认的起始分支名字，原因仅仅是它的广泛使用， “origin” 是当你运行 `git clone` 时默认的远程仓库名字。 如果你运行 `git clone -o booyah`，那么你默认的远程分支名字将会是 `booyah/master`。

##### 选择二：`git pull`

如果想让当前分支变成最新，且当前分支是个跟踪分支，那可以`git pull`来自动进行`git fetch <remote-name>/ <branch-name>` + `git merge <remote-name>/<branch-name>`的操作。常用！

### 2. 推送数据

`git push`：将整个本地仓库或者某个分支的数据同步到指定仓库上去。

### 3. 创建跟踪分支

创建跟踪分支是很常用的做法，一一对应的关系能让我们进行方便的操作（比如`git pull`），也能避免困惑。

有两种指令适用：

1. `git switch`。2.23版本出现的新王，取代了下面那位。

   `git switch --track <remote-name>/<branch-name>`。

   如果 a) 这个跟踪分支之前不存在 b) 只有一个同名远程跟踪分支，那`git switch <branch-name>`足矣。

2. `git checkout`。

   `git checkout --track <remote-name>/<branch-name>`

   如果 a) 这个跟踪分支之前不存在 b) 只有一个同名远程跟踪分支，那`git checkout <branch-name>`足矣。

跟踪分支不一定需要和上游分支同名，但不常用，具体操作请google吧 (☞ﾟヮﾟ)☞

### 4. 特殊的场景：

1. 我有一个新创建的分支，该如何推送？`git push`就完事儿了。不需要特殊处理。
2. 远程仓库上出现了一个新的分支，我该如何拉取？`git fetch`，这样你本地仓库就有相对应的远程跟踪分支了，可以选择创建跟踪分支（常用）或者将改动merge到现有分支上去。



---

## 浪子回头（撤销修改，回到过去）

*以下全是本地操作*

### 1. `git restore`

**新时代滴王！存在的意义：取代`git checkout`的恢复内容的功能。`git checkout`做的事情太多了，对用户不友好。**

通过指定源头，将工作区或者暂存区的指定路径的内容恢复。

如果想要恢复工作区的内容，源头默认为当前暂存区。默认恢复源头，也可以通过`--worktree`来指定。

如果想要恢复暂存区的内容，源头默认为`HEAD`。通过`--staged`来指定恢复暂存区。

举例：

1. `git restore .`恢复工作区所有内容。
2. `git restore --source master~2 Makefile`将工作区中的Makefile恢复成master分支的父节点的父节点的快照中的样子。
3. `git restore --staged --worktree --source=HAED~ .`将工作区和暂存区所有文件恢复成HEAD的父节点的快照中的样子。

### 2. `git checkout`

将工作区和暂存区全部或者某些文件变成指定版本的样子。

如果工作区和暂存区有未提交的、和指定快照有冲突的修改，那么此操作无法进行（保证了安全性，不覆盖未保存的修改）。

举例：`git checkout Makefile`将Makefile恢复到上个版本（即HEAD）的样子。

### 3. `git reset`

`git reset`可以`--soft`，`--mixed`，或者`--hard`，这三种操作各有什么效果？

`git reset --soft  <hash value>`：将`HEAD`指向对应的commit

`git reset --mixed <hash value>`：将`HEAD`指向对应的commit + 将指向的快照放入暂存区中

`git reset --hard  <hash value>`：将`HEAD`指向对应的commit + 将指向的快照放入暂存区中 + 将暂存区的快照放入工作区中

也可以指定路径来reset某个文件或者文件及和，而非整个快照。（当然，如果指定文件名了，那么第一步是会跳过的，毕竟没有一个指针指向两个commit的道理。而暂存区和工作区是可以部分修改的，所以第二步第三步还是会继续做的）



如此一来，各个`git reset`的用途就很明显了：

***应用场景1：我刚刚的commit message写错了，或者我忘了加入某个文件。我想重新提交，但不想弄乱log***

`git reset --soft HEAD^` 来将`HEAD`指向上次的commit，稍加修改后重新提交。此处的`HEAD^`指`HEAD`的第一个父节点（这些特殊用法在最后会讲）。这些操作其实等同于`git commit --amend`。

***应用场景2：我的提交太琐碎了，我想把最近的提交压缩一下***

`git reset --soft <hash value>`到想要保留的最新commit，在进行一次提交，即可压缩掉中间的commits。

***应用场景2：我想将某个文件从踢出暂存区（unstage）***

`git reset --mixed HEAD <filename>`

***应用场景3：我想取消暂存所有东西！***

`git reset --mixed HEAD`

***应用场景4：我什么都不想要了，我要一切都回到某个版本***

`git reset --hard <hash value>` （危险操作，会强行覆盖工作区所有文件，三思）



当然，有些人可能感觉`checkout` 和 `reset --hard`功能一摸一样。其实不然，checkout不会覆盖工作区中已经修改的文件，而reset会强行覆盖。一个安全，一个危险哦。	

还有一个重要区别：`checkout`只会移动`HEAD`自身，而`reset`会移动`HEAD`所在的分支的指向（毕竟这才是为什么我们想要`reset --hard`：为了恢复一切，包括commit记录。分支的指向不变的话，想抛弃的父节点commit依旧还在那里，新的commit的父节点也还是最新的commit）。

> 例如，假设我们有 `master` 和 `develop` 分支，它们分别指向不同的提交；我们现在在 `develop` 上（所以 HEAD 指向它）。 如果我们运行 `git reset master`，那么 `develop` 自身现在会和 `master` 指向同一个提交。 而如果我们运行 `git checkout master` 的话，`develop` 不会移动，HEAD 自身会移动。 现在 HEAD 将会指向 `master`。



---

## 一些其他~~花哨~~实用指令

### 1. `git stash`

贮藏当前工作区和暂存区的修改到一个特殊的栈上。

非常实用！

举例：我正在`brand-new-feature`这个分支上工作，突然被告知我需要修改一个外网bug！但是手头上的修改还没到可以提交的程度，就通过`git stash`在贮藏手头上的修改，优雅地新建一个分支`iss777`去修bug了。

[点此查看《Pro Git》的讲解](https://git-scm.com/book/zh/v2/Git-%E5%B7%A5%E5%85%B7-%E8%B4%AE%E8%97%8F%E4%B8%8E%E6%B8%85%E7%90%86)

### 2. `git alias`

自定义化Git，重现`svn ci`的简便！

[点此查看《Pro Git》的讲解](https://git-scm.com/book/zh/v2/Git-%E5%9F%BA%E7%A1%80-Git-%E5%88%AB%E5%90%8D)



---

## 断头（detached HEAD）

当`HEAD`直接指向具体的commit，而非指向分支指针。

发生的原因：`git checkout <hash value>`到了之前的commit，或者`git switch --detach`等指令。

断头状态下的效果：HEAD没有指向任何一个分支 -> 本地没有一个跟踪分支 -> 做出的修改很容易无法找回

举例：当我们checkout到commit 2并进行一次提交后，新产生的commit 5就指向了commit 2。此时commit 5所在的“分支”是其实是不存在的，离开以后我们就回不来了。

![Enter image description here](https://i.stack.imgur.com/OlavO.png)

断头状态也是有用的：如果你想在某个之前的commit开一个新的分支，就可以将HEAD移动到那里后创建新分支。



---

## git checkout王朝的陨落

Git 2.23版本引入了`git restore`和`git switch`，分别取代了`git checkout`的恢复内容功能和切换分支功能。

原因就是`git checkout`能做的事情太多了，过于底层，于是更高层的、功能更具体纯粹的两个指令瓜分了`git checkout`统治的两个重要领土。

我现在很难找到使用`git checkout`的理由了。

有人可能想问：那`git checkout`可以随意移动`HEAD`呀？其他指令能做到吗？

答：`git switch --detach`能做到( ͡• ͜ʖ ͡• )

问：`git checkout`能保证所有操作都是安全的，不会删除或覆盖未提交的修改！

答：`restore`和`switch`也具有严格的安全性(￣ε(#￣)

不过现在这两个指令还是实验性质，功能也许会改变，为了求稳（或者说git 版本更新不上去）的话`git checkout`还是很可靠的。



---

## 子模块（submodule）

子模块有点复杂，brace yourself!

> 子模块允许你将一个 Git 仓库作为另一个 Git 仓库的子目录。 它能让你将另一个仓库克隆到自己的项目中，同时还保持提交的独立。



### 讲解指令之前，先了解下子模块是如何存在的

子模块在主项目中是以***同名文件夹***形式存在的。

```
$ ls -1 main_repo
server/
utilities/
submodule_1/
submodule_2/
...
```

虽然它以文件夹的形式存在，但是在***主项目***的版本记录中，这个文件夹中的具体内容不会被记录——整个文件夹被看作子模块的一个commit。

主项目会记录子模块的相应commit，保证别人克隆时得到的子模块内容一致。

另外注意：子模块是断头状态。这意味着我们想要在主项目这里直接修改子模块的内容并提交的话，需要多做几步。

### 添加子模块

指令：`git submodule add <url_of_submodule>`

效果：

1. 被添加的子模块被放入咱们主项目下的同名文件夹下面。
2. `.gitmodule`文件中会新增一个entry，来记录这个子模块的映射。没有此文件则新建后添加。此文件是克隆主项目的人获取子模块信息的来源，所以它同样会受到版本控制。
3. 在主项目下提交即可。

### 克隆含有子模块的项目

默认克隆一个含有子模块的项目后，子模块对应的文件夹是空的。

你可以进入那个文件夹`git submodule init` + `git submodule update`来获取该子模块的数据并且检出正确的commit。

当然，最方便的还是`git clone --recursive-submodules`，直接拉取所有子模块的数据并检出相应版本。

### 在含有子模块的项目上工作

#### 1. 拉取子模块的最新数据

你可以进入相应文件夹，手动`git fetch` + `git merge`。

也可以`git submodule update --remote [<submodule-name>]`来直接获取一个或者所有submodule的数据。不过这个指令默认更新的是master branch数据，你可以通过`git config -f .gitmodules submodule.<submodule-name>.branch <branch-name>`改变主项目需要的这个子模块分支。

#### 2. 拉取含有子模块的主项目的最新数据

如果运行`git pull`拉取主项目的最新数据，`git pull` 命令会递归地抓取子模块的更改，然而，它不会 **更新** 子模块。

为了完成更新，你需要运行 `git submodule update --init --recursive`。加`--init`是为了可能的新子模块。

在为父级项目拉取更新时，还会出现一种特殊的情况：在你拉取的提交中， 可能 `.gitmodules` 文件中记录的子模块的 URL 发生了改变。这个时候，需要先运行`git submodule sync --recursive`

#### 3. 在主项目下修改子模块

当我们运行`git submodule update`获取子模块的内容后，子模块的会变成**断头状态**：这意味着没有一个本地的跟踪分支，我们所做的修改即便提交了也很可能会丢失。

为了正确修改子模块的内容：

1. 进入对应文件夹，检出想要的分支。此步创建了一个本地的跟踪分支，脱离了断头状态。
2. 做点修改，提交，上传。

有人可能想问了：如果子模块的远程仓库也有更新怎么办，上传前需要拉取最新数据并且更新怎么办？不是说`git submodule update --remote`会把项目变成主项目记录的状态，然后把它断头吗？

答：不用担心，你做了修改的本地分支还在的。你可以检出那个本地分支后手动merge 或者rebase，或者方便地使用`git submodule update --remote <--merge/--rebase>`.

#### 4. 上传子模块的改动 + 合并子模块的改动

[详见“发布子模块改动”和“合并子模块改动”片段](https://git-scm.com/book/zh/v2/Git-%E5%B7%A5%E5%85%B7-%E5%AD%90%E6%A8%A1%E5%9D%97)