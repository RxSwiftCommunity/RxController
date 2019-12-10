# RxTree

RxController provides a command line tool `rxtree` to print the relationship among flows and view controllers,
just like using the `tree` command.

```shell
➜  ./rxtree MainFlow
MainFlow
├── ProjectFlow
│   ├── RequestFlow
│   │   ├── AddProjectViewController
│   │   ├── RequestViewController
│   │   ├── ResultViewController
│   │   ├── SaveToProjectViewController
│   ├── ProjectIntroductionViewController
│   ├── ProjectNameViewController
│   ├── ProjectViewController
│   ├── ProjectsViewController
├── RequestFlow
│   ├── AddProjectViewController
│   ├── RequestViewController
│   ├── ResultViewController
│   ├── SaveToProjectViewController
├── SettingsFlow
│   ├── IPAddressViewController
│   ├── PingViewController
│   ├── SettingsViewController
│   ├── WhoisViewController
├── AddProjectViewController
```

### Install RxTree with CocoaPods

`rxtree` relays on the design of RxController. 
Once RxController updated, the old version of `rxtree` may be noneffective.
For this reason, it is recommend to be installed with `post_install` of CocoaPods.

```ruby
post_install do |installer|
  system("bash #{Pathname(installer.sandbox.root)}/RxController/rxtree/build_for_xcode.sh")
end
```

Once `pod install` or `pod update` is executed, the corresponding version of `rxtree` will be installed at the same time. 

### Use RxTree

The executed file `rxtree` will be copied to the root directory of the project.
A **root node** which can be a subclass of `Flow` or a subclass of `RxViewController` must be selected as the root of the tree.

```shell
./rxtree MainFlow
```

To prevent recustion calling, the default max levels of `rxtree` is 10.
It means that only 10 levels of flows and view controllers will be listed by default.
To change the value of max levels, use the paramter `maxLevels`.

```shell
./rxtree MainFlow --maxLevels 5
```
