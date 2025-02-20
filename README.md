# README BOOKWATCHMAN #

## Jak postupovat při pullnutí projekt aby šel projekt spustit ##
* v rámci terminálu v hlavním adresáří (kde je soubor Podfile) bude potřeba napsat příkaz:
    pod install
    * to stáhne a nainstaluje balíčky z Podfile do projektu
* poté stačí projekt otevřít přes soubor BookWatchman.xcworkspace
* v rámci chyb a warningů je možný, že bude xcode vyhazovat warningy na zastaralý deployment ios version, tak při kliknutí na warning se otevře settings balíčku a tam zvolit deployment ios verzi na 17.5 z nějaké verze 9/10 atp.
* pak je možně že bude vyskakovat chyba s nějakým frameworkem a duplicitními knihovnami, tak tu ignorovat
* Dál už je projekt funkční a muže se pracovat

## Jak vložit screeny do simulátoru ##
* Ve složce __Files_For_Simulator__ jsou obrázky/screeny pro simulátor
* Pro vložení obrázku do simulátoru stačí přetáhnout soubory na otevřený simulátor a obrázky se vloží do galerie
* Poté budou v rámci galerie dostupné pro použití v programu

## Secrets.xcconfig vložit do složky BookWatchman, kde je phone implementace (na úroveň vedle view/model/... složek)
* V secrets bude následující:
* * V případě s Cocoapods:
#include "Pods/Target Support Files/Pods-BookWatchman/Pods-BookWatchman.debug.xcconfig"
#include "Pods/Target Support Files/Pods-BookWatchman/Pods-BookWatchman.release.xcconfig"
API_KEY=google_api_key
* * V případě bez Cocoapods:
API_KEY=google_api_key