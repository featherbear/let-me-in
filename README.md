> This repo isn't very useful for you.  
> It's just a collection of copy-pastas for my sysadmin stuff

---

_But otherwise..._

[![let-me-in.png](https://i.kym-cdn.com/photos/images/newsfeed/001/461/623/b21.png)](https://featherbear.cc/UNSW-COMP6441/blog/post/passwords/#try-it-out)

---

## Install public ssh key

```bash
# Normal
curl -sL https://raw.githubusercontent.com/featherbear/let-me-in/master/letmein.sh | bash -

# For inbound-only machines (i.e. outbound connections are blocked)
curl -sL https://raw.githubusercontent.com/featherbear/let-me-in/master/letmein.legacy.sh | bash -
```
