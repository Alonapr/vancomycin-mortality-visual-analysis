load("vancomycin.RData")
dim(dat)
summary(dat)

# Ziel: untersuchen, welche Faktoren die Sterblichkeit der Patienten beeinflussen, 
# die mit Vancomycin behandelt wurden.

# Von Interesse: Demografische Daten, Nierenfunktion, Schweregrad der Erkrankung,
# Daten über Vancomycin-Therapie

# Vorbereitung der Daten
# Erstellen der binären Variable starus für Sterblichkeit. 
# Es wird angenommen, dass NA-Werte die lebende Menschen kennzeichnen.
dat$status <- ifelse(is.na(dat$Mortalitydate), "lebend", "verstorben")
dat$status <- factor(dat$status, levels = c("lebend", "verstorben"))
table(dat$status)

# Alter aus der Birthdate berechnen zum Beginn der Therapie
dat$Age <- floor(as.numeric(difftime(as.Date(dat$Start), as.Date(dat$Birthdate),
                                    units = "days")) / 365.25)
summary(dat$Age)

# Farben für Status definieren
darkgreen_soft <- adjustcolor("darkgreen", alpha.f = 0.7)
red_soft <- adjustcolor("firebrick3", alpha.f = 0.8)
farben <- c(darkgreen_soft, red_soft)
################################################################################
# Alter nach Status
lebend_data <- dat$Age[dat$status == "lebend"]
verstorben_data <- dat$Age[dat$status == "verstorben"]
summary(lebend_data)
summary(verstorben_data)

windows(width = 8, height = 3)
opar <- par(mar = c(4.5, 2, 0.2, 7),
            cex = 1.3)
boxplot(Age ~ status, data = dat, col = farben, yaxt = "n",
        ylab = "", xlab = "", horizontal = TRUE)
title(ylab = "Status", line = 0.5)
title(xlab = "Alter", line = 2)
legend("topright", inset = c(-0.32, 0), legend = c("lebend", "verstorben"), 
       fill = farben, title = "Status", cex = 1.1, bty = "n", xpd = TRUE)

# SAPS- und SOFA-Score nach Status
windows(width = 8, height = 5)
opar <- par(mfrow = c(2,1), mar = c(4, 2, 0.2, 7),
            cex = 1.3)
boxplot(SAPS ~ status, data = dat, col = farben, horizontal = TRUE, 
        xlab = "", ylab = "", yaxt = "n")
title(ylab = "Status", line = 0.5)
title(xlab = "SAPS-Score", line = 2.1)
legend("topright", inset = c(-0.32, 0), legend = c("lebend", "verstorben"), 
       fill = farben, title = "Status", cex = 1.1, bty = "n", xpd = TRUE)
boxplot(SOFA ~ status, data = dat, col = farben, horizontal = TRUE, 
        xlab = "", ylab = "", yaxt = "n")
title(ylab = "Status", line = 0.5)
title(xlab = "SOFA-Score", line = 2.1)

# Nierenfunktion: Untersuche, ob die Nierenfunktion die Mortalität beeinflusst,
# da Vancomycin bekanntermaßen nephrotoxisch sein kann.

windows(width = 10, height = 5.5)
opar <- par(mfrow = c(1,2), mar = c(4, 4.5, 0.2, 0.8),
            las = 1, cex.axis = 1.3, cex.lab = 1.25)
# Mittelwerte für SCr (Serumkreatinin) nach Status
lebend_means <- colMeans(dat[dat$status == "lebend", 
                             c("SCrStart", "SCr24", "SCr48", "SCr72", "SCrEnd")], na.rm = TRUE)
verstorben_means <- colMeans(dat[dat$status == "verstorben", 
                                 c("SCrStart", "SCr24", "SCr48", "SCr72", "SCrEnd")], na.rm = TRUE)

# Liniendiagramm für Serumkreatinin (SCr)
plot(1:5, lebend_means, type = "b", col = darkgreen_soft, 
     xlab = "Zeitpunkte der Therapie", 
     ylab = "Durchschnittlicher Serumkreatininspiegel (mg/dL)", 
     ylim = c(0.7, 1.2), xaxt = "n", lwd = 2, las = 1)
axis(1, at = 1:5, labels = c("Start", "24Std.", "48Std.", "72Std.", "Ende"))
lines(1:5, verstorben_means, type = "b", col = red_soft, lwd = 2)
legend("topleft", legend = c("Lebend", "Verstorben"), 
       col = farben, lwd = 2, cex = 1.2)

# Mittelwerte für eGFR (geschätzte glomeruläre Filtrationsrate) nach Status
lebend_means <- colMeans(dat[dat$status == "lebend", 
                c("eGFRStart", "eGFR24", "eGFR48", "eGFR72", "eGFREnd")], na.rm = TRUE)
verstorben_means <- colMeans(dat[dat$status == "verstorben", 
                c("eGFRStart", "eGFR24", "eGFR48", "eGFR72", "eGFREnd")], na.rm = TRUE)

# Liniendiagramm für eGFR (geschätzte glomeruläre Filtrationsrate)
plot(1:5, lebend_means, type = "b", col = darkgreen_soft, 
     xlab = "Zeitpunkte der Therapie", 
     ylab = "Durchschnittliche eGFR (mL/min/1.73m²)", 
     ylim = c(75,105), xaxt = "n", lwd = 2, las = 1)
axis(1, at = 1:5, labels = c("Start", "24Std.", "48Std.", "72Std.", "Ende"))
lines(1:5, verstorben_means, type = "b", col = red_soft, lwd = 2)



# Zusammenhang zwischen Vancomycin-Dosis, Serumspiegeln, Nierenfunktion und Sterblichkeit

# Panel-Funktion für Regressionslinien
panel.lm <- function(x, y, ...) {
  points(x, y, bg = farben[dat$status], pch = 21, col = NA)
  abline(lm(y ~ x), col = "black", lwd = 2)
}

# Funktion für Histogramme im Diagonalpanel
panel.hist <- function(x, ...) {
  usr <- par("usr")
  par(usr = c(usr[1:2], 0, 1.5))
  h <- hist(x, plot = FALSE)
  breaks <- h$breaks
  nB <- length(breaks)
  y <- h$counts
  y <- y / max(y)
  rect(breaks[-nB], 0, breaks[-1], y, col = "lightgrey", ...)
  box()
}

# Panel-Funktion für Korrelationen
panel.cor <- function(x, y, ...) {
  par(usr = c(0, 1, 0, 1))
  r <- cor(x, y, use = "complete.obs", method = "spearman")
  txt <- format(r, digits = 2)
  text(0.5, 0.5, txt, cex = 2)
}

windows(width = 10, height = 9)
opar <- par(las = 1)  
vars <- c("SCr24", "eGFR24", "MD24", "C24")
pairs(dat[, vars], labels = vars, pch = 21, gap = 0,
      bg = farben[dat$status], cex.axis = 1.5, cex.labels = 2, 
      lower.panel = panel.lm, diag.panel = panel.hist, 
      upper.panel = panel.cor, oma = c(2.8, 3, 9, 2.8))
legend(x = "top", title = "Status", pt.bg = farben, cex = 1.5, xpd = TRUE, 
       legend = levels(dat$status), pch = 21, bty = "n", col = NA, 
       horiz = TRUE, inset = c(0, -0.02)) 
par(opar)
