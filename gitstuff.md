# .gitconfig ja pohjat

Helpottaa elämää, jos nämä löytyvät ~/.gitconfig -filestä.

```
[alias]
	ci = commit
	st = status
	co = checkout
	br = branch
	glog = log --graph --pretty=oneline --abbrev-commit --decorate

[log]
	decorate = full
```

Tutoriaalia varten tarvitaan paikallinen git-repo ja sinne tiedosto.

```
$ mkdir gittut

$ cd gittut

$ git init
Initialized empty Git repository in /Users/jteuho/Documents/gittut/.git/

$ echo "First things first" > README

$ git add README

$ git ci -m 'First thing'
[master (root-commit) ae903b5] First thing
 1 file changed, 1 insertion(+)
 create mode 100644 README

$ git st
On branch master
nothing to commit, working directory clean

$ ls
README

$ git glog
* ae903b5 (HEAD, master) First thing
```

Ensimmäinen commit masteriin tehty. Riemuitkaa, kansalaiset.

# Branch

Pidemmän featuren kehitys on hyvä pitää omassa haarassaan. Tehdään sellainen.

```
$ git co -b fancy_feature
Switched to a new branch 'fancy_feature'

$ git st
On branch fancy_feature
nothing to commit, working directory clean

$ vim README
    ... here be the magic
$ cat README
First things first

Feature thing

$ git ci -a -m 'Feature thing'
[fancy_feature 8cf544b] Feature thing
 1 file changed, 2 insertions(+)

$ git glog
* 8cf544b (HEAD, fancy_feature) Feature thing
* ae903b5 (master) First thing

$ git glog master
* ae903b5 (master) First thing
```

Eli lisättiin rivin verran tekstiä ja commitoitiin muutos. Masterin HEAD on
siinä mihin se jäi ennen haaran tekoa, eikä siellä tiedetä hienosta featuresta
tuon taivaallista. Feature branchin HEAD on tuoreessa commitissa.

Palataan takaisin masteriin ja mergetään muutokset sinne.

```
$ git co master
Switched to branch 'master'

$ git merge fancy_feature
Updating ae903b5..8cf544b
Fast-forward
 README | 2 ++
 1 file changed, 2 insertions(+)

$ git glog
* 8cf544b (HEAD, master, fancy_feature) Feature thing
* ae903b5 First thing
```

Haarassa tehdyt muutokset on tuotu masteriin, ja sekä feature-haaran että
masterin päät osoittavat samaan committin. Jos feature-haara poistetaan,
näyttää kuin sitä ei olisi koskaan ollutkaan.

```
$ git br -d fancy_feature
Deleted branch fancy_feature (was 8cf544b).

$ git glog
* 8cf544b (HEAD, master) Feature thing
* ae903b5 First thing
```

# merge, slow-forward

```
$ git co -b another_feature
Switched to a new branch 'another_feature'

$ vim README

$ git ci -a -m 'Another feature thing'

 1 file changed, 2 insertions(+)

$ git co master
Switched to branch 'master'

$ git merge --no-ff another_feature
    ... Tässä kohtaa git pyytää editoimaan merge commitin viestiä
Merge made by the 'recursive' strategy.
 README | 2 ++
 1 file changed, 2 insertions(+)

$ git glog
*   f4945a9 (HEAD, master) Merge branch 'another_feature'
|\
| * eb3e8f8 (another_feature) Another feature thing
|/
* 8cf544b Feature thing
* ae903b5 First thing

$ git br -d another_feature
Deleted branch another_feature (was eb3e8f8).

$ git glog
*   f4945a9 (HEAD, master) Merge branch 'another_feature'
|\
| * eb3e8f8 Another feature thing
|/
* 8cf544b Feature thing
* ae903b5 First thing
```

Merge tehtiin ilman fast-forwardia. Nyt historiaan jää tieto siitä, mitkä
commitit tehtiin haarassa ja tieto säilyy vaikka haara poistettiin.

No-fast-forward on yleisesti niin hyvä default, että se kannattaa sisällyttää
omaan .gitconfigiin

```
[merge]
        ff = false
```

# Rebase

Jos kehityshaarassa touhuilun aikana joku muu livauttaa commitin masteriin,
täytyy haara rebaseta. Tämä siirtää haaroituskohdan masterin uuteen kärkeen
ja pitää huolta siitä, että mergen tullessa historia pysyy siivona.

Tehdään uusi haara ja sinne muutos.

```
$ git co -b long_feature
Switched to a new branch 'long_feature'

$ vim README

$ cat README
First things first

Feature thing

Another feature thing

First long thing

$ git ci -a -m 'First long'
[long_feature daf08c5] First long
 1 file changed, 2 insertions(+)

$ git glog
* daf08c5 (HEAD, long_feature) First long
*   f4945a9 (master) Merge branch 'another_feature'
|\
| * eb3e8f8 Another feature thing
|/
* 8cf544b Feature thing
* ae903b5 First thing
```

Käydään tässä välissä tekemässä commit masteriin.

```
$ git co master
Switched to branch 'master'

$ vim README
    ... Lisätään toinen juttu
$ cat README
First things first

Second things second

Feature thing

Another feature thing

$ git ci -a -m 'Second thing'
[master d3a7de0] Second thing
 1 file changed, 2 insertions(+)

$ git glog
* d3a7de0 (HEAD, master) Second thing
*   f4945a9 Merge branch 'another_feature'
|\
| * eb3e8f8 Another feature thing
|/
* 8cf544b Feature thing
* ae903b5 First thing

$ git glog long_feature
* daf08c5 (long_feature) First long
*   f4945a9 Merge branch 'another_feature'
|\
| * eb3e8f8 Another feature thing
|/
* 8cf544b Feature thing
* ae903b5 First thing
```

`Master` ja `long_feature`ovat nyt erkaantuneet toisistaan yhden commitin
verran. Palataan kehityshaaraan ja laitetaan sisään toinen commit.

```
$ git co long_feature
Switched to branch 'long_feature'

$ vim README

$ cat README
First things first

Feature thing

Another feature thing

First long thing

Second long thing

$ git ci -a -m 'Second long'
[long_feature c753cd9] Second long
 1 file changed, 2 insertions(+)

$ git glog
* c753cd9 (HEAD, long_feature) Second long
* daf08c5 First long
*   f4945a9 Merge branch 'another_feature'
|\
| * eb3e8f8 Another feature thing
|/
* 8cf544b Feature thing
* ae903b5 First thing

$ git glog master
* d3a7de0 (master) Second thing
*   f4945a9 Merge branch 'another_feature'
|\
| * eb3e8f8 Another feature thing
|/
* 8cf544b Feature thing
* ae903b5 First thing
```

Haaran logissa ei tällä kertaa näy tietoa masterin HEAD-commitista, koska
sitä ei ole tähän haaraan koskaan tuotu. Tuodaan se.

```
$ git rebase master
First, rewinding head to replay your work on top of it...
Applying: First long
Applying: Second long

$ git glog
* bb57746 (HEAD, long_feature) Second long
* 339f856 First long
* d3a7de0 (master) Second thing
*   f4945a9 Merge branch 'another_feature'
|\
| * eb3e8f8 Another feature thing
|/
* 8cf544b Feature thing
* ae903b5 First thing
```

Ja koska pitkä feature on valmis, viedään tuotokset masteriin.

```
$ git co master
Switched to branch 'master'
[16:03] ~/Documents/gittut
$ git merge --no-ff long_feature
Merge made by the 'recursive' strategy.
 README | 4 ++++
 1 file changed, 4 insertions(+)

$ git glog
*   6f57aab (HEAD, master) Merge branch 'long_feature'
|\
| * bb57746 (long_feature) Second long
| * 339f856 First long
|/
* d3a7de0 Second thing
*   f4945a9 Merge branch 'another_feature'
|\
| * eb3e8f8 Another feature thing
|/
* 8cf544b Feature thing
* ae903b5 First thing
```
