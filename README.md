
![lol](./misc/soup.png)

# borsch language / язык программирования для борщей

**Борщленг** - это стековый язык программирования созданный,
чтобы погрузится в нескучный мир шизы. 

---

## Билд из сорцов(пример на шиндовс(остальные сами додумаются)):
```
dart2native .\cli.dart -o borsch.exe
.\borsch.exe
```

### CLI:
```
cli namefile [-keys]
cli run 'code' [-keys]
```

### "Hello, World!"
```
.\borsch.exe run "'Hello, World!' println"
```

### Горячий тур по языку:
[./misc/tour.txt](./misc/tour.txt)

--------------------------------------------------------------

Факториал:
```forth
[ 1 fact set range [ fact get * fact set ] each fact get ] factorial const
5 factorial call ( 120 )
```
