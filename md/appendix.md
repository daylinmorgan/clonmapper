# Appendix

See below for general purpose procedures related
to ClonMapper.

## AmpureXP Bead PCR Cleanup

<!-- TODO: write info section here
  If there are considerable peaks at 120 bp or less,
  SPRI bead cleanup can be repeated with 1.1X beads to
  further purify PCR sample, but this will greatly reduce yield.
-->

1. Transfer 50 \unit{\uL} PCR amplification product to a
   nuclease-free microcentrifuge tube
1. Allow AmpureXP beads to come to room temperature.
1. Add 35 \unit{\uL} (0.7X) AmpureXP beads and mix
   well with vortexing or pipetting up and down 10 times.
1. Incubate at room temperature for 5 minutes.
1. Place the tube on a magnetic rack and allow solution to clear (5-10 minutes).
1. While the tube is on the rack transfer the clear supernatant
   to a new tube without disturbing the bead pellet.
1. Add 45 \unit{\uL} (1.6-0.7x) AmpureXP beads to the supernatant
   from step 10 and mix well with vortexing or pipetting up and down 10 times.
1. Incubate at room temperature for 5 minutes.
1. Place the tube on a magnetic rack and allow solution to clear (5-10 minutes).
1. With the tube still in the rack, aspirate the clear supernatant.
1. With the tube still in the rack, add 180 \unit{\uL} of 80% ethanol and
   allow it to sit for 30 seconds.[^cleanup-1]
1. With the tube still in the rack, aspirate the ethanol and repeat step 14.
1. Remove supernatant and allow bead to dry for no **more** than 5 minutes.[^cleanup-2]
1. Remove tube from the magnetic rack and elute DNA
   by adding 42 \unit{\uL} of nuclease-free water.
1. Incubate at room temperature for 10 minutes.
1. Transfer tube to magnetic rack and collect 40 \unit{\uL} of purified
   PCR product after solution has cleared (5-10 minutes).[^cleanup-3]
1. Quantify DNA yield with a high sensitivity fluorometry kit
   ensuring yield between 0.5-10 ng/\unit{\uL}.


[^cleanup-1]: 80% ethanol should be prepared fresh for each PCR cleanup.
[^cleanup-2]: Do not over dry the beads, this can result in a loss of yield and quality.
[^cleanup-3]: Beads may become trapped within the meniscus of the water.
  Pipetting slowly will keep the beads against the wall of the tube
  and leave them in the remaining 2 \unit{\uL} of water.


## Determine Viral Titer


See [^28]^,^[^29]

### Titering on Adherent Cells (Forward Procedure)

[^30]

1. 24-48 hours before performing viral transduction seed your
   cell line of interest in a 12-well plate such that it is
   near 60-70% confluent at time of transduction.
1. Prior to transduction, one well of the replicate 12 wells should
   be dissociated and counted using trypan blue exclusion on a
   hemocytometer to know approximate number of live cells at
   time of transduction.[^31]^,^[^32]
1. Create stock of media containing your cells' standard growth medium
   supplemented with 20% FBS containing 0-10 \unit{\ug\per\mL} hexadimethrine
   bromide (1:1000 dilution from hexadimethrine bromide stock to get 10 \unit{\ug\per\mL}).[^33]
1. Place 600 \unit{\uL} of hexadimethrine bromide containing medium
   into separate microcentrifuge tubes.
1. Add virus in increasing amounts to each tube.
1. Replace media on cells of interest with virus and
   hexadimethrine bromide containing dilutions.
1. Incubate for 16 hrs at 37 °C, then carefully remove viral containing
   supernatant and replace with complete growth medium.[^35]^,^[^36]
1. Incubate for an additional 32 hrs at 37 °C, then remove medium
   and wash each well gently with PBS.[^37]
1. Dissociate the cells from the plate
   and centrifuge at 300 x g for 5 minutes at 4 °C.
1. Wash cell pellets with PBS and repeat spin.
   Perform this step three times to ensure removal
   of trace virus before flow cytometry.
1. Resuspend cells in chilled FACS Buffer.[^38]
1. Keep cells on ice and continue to step [*Flow Cytometry to Determine Viral Titer*](#flow-cytometry-to-determine-viral-titer)

[^28]: Viral titer will vary between cell type and with each new virus preparation.
[^29]: Lentivirus susceptibility and timing should first be determined
  on your cells of interest using a control plasmid such as
  a constitutively active GFP. Some cells will require longer
  or shorter incubation times with the virus and some cells will
  take longer to produce the transgenic reporter protein.
<!-- TODO: make sure these steps below are accurate -->
[^30]: To perform reverse titer on adherent cells, follow the steps
  for titering on suspension cells through step 3.4.2.5,
  then return to the adherent protocol at step 3.4.1.6.
[^31]: It is very important to know the number of cells at the time
  of transduction. This number is used to calculate viral titer.
[^32]: Trypan blue exclusion is performed by mixing equal parts 0.05%
  Trypan blue with your cell suspension, usually 10 \unit{\uL} of each,
  then load 10 \unit{\uL} of the stained suspension into the hemocytometer.
[^33]: Hexadimethrine bromide is a cationic solution that assists
  in viral adsorption to cells [@davis2002].
  Hexadimethrine bromide can be toxic to some cells.
  Hexadimethrine bromide sensitivity should be assessed via serial dilution
  to determine maximum tolerable hexadimethrine bromide dose before
  determining viral titer. Most cells respond well to 6-8 \unit{\ug\per\mL}
  hexadimethrine bromide.
[^34]: Ensure one well is kept uninfected as a negative control.
  A range of 0.5-200 \unit{\uL} is usually sufficient to find viral titer,
  e.g. 0, 0.5, 1, 5, 10, 25, 50, 100, 150, 200 \unit{\uL}.
[^35]: Lentiviral exposure time will vary across cell type dependent
  on growth dynamics and properties intrinsic to the cells.
  Optimize lentiviral exposure time with constitutively active
  GFP virus before transduction with sgRNA barcoding library virus.
[^36]: Lentiviral exposure times range between 12-48 hours.
  Lentiviral exposure time should be minimized to reduce
  the occurrence of multiple viral integrations.
[^37]: Lentivirus transduced cells are very fragile
  and should be handled with added care.
[^38]: EDTA and FBS in FACS buffer help to prevent cell clumping.
  For extra-sticky cells, use 5 \unit{\mM} EDTA in FACS buffer.


### Titering on Suspension Cells

1. Count your cells of interest using a hemocytometer.
1. Create stock of media containing your cells' standard growth medium
  supplemented with 20% FBS containing 0-10 \unit{\ug\per\mL} hexadimethrine bromide
  (1:1000 dilution from hexadimethrine bromide stock for 10 \unit{\ug\per\mL}).[^33]
1. Resuspend 1.20 x 10^6^ cells in 7.2 mL of containing hexadimethrine bromide
   media such that the final solution contains 1 x 10^5^ cells in 600 \unit{\uL}.
1. Plate 600 \unit{\uL} of cell solution in 10 wells
   of a tissue culture treated 12-well plate
1. Add virus in increasing amounts to each well and mix well.[^34]
1. Incubate for 16 hrs at 37 °C.[^35]^,^[^36]
1. Transfer cell suspensions to sterile 1.7 mL microcentrifuge tubes
   and spin down at 500 x g for 5 minutes at 4 °C.[^39]
1. Resuspend each cell pellet with complete growth medium
   and transfer to fresh 12-well plate.
1. Incubate for an additional 32 hrs at 37 °C, then transfer wells to
   microcentrifuge tubes and spin down at 400 x g for 5 minutes at 4 °C.[^40]
1. Wash cell pellets with PBS and repeat spin.[^41]
1. Resuspend cells in chilled FACS Buffer.[^38]
1. Keep cells on ice and continue to step [*Flow Cytometry to Determine Viral Titer*](#flow-cytometry-to-determine-viral-titer)

[^39]: Use a pipette to remove lentivirus containing supernatant
  and dispose of in bleach. Do not vacuum aspirate, vacuums can cause dangerous viral aerosols.
[^40]: Lentivirus transduced cells are very fragile
  and should be handled with added care when pipetting.
[^41]: Perform this step three times to ensure removal of trace virus before flow cytometry.

### Flow Cytometry to Determine Viral Titer

1. Pass cells resuspended in FACS buffer through a 35 \unit{\um} nylon mesh strainer
   into a 5 \unit{\mL} flow cytometry test tube.[^42]
1. Use control samples to set laser voltages on FSC-A, SSC-A,
   and BFP such that nearly all cells are seen within FSC-A vs. SSC-A plot and
   both negative and positive populations can be seen and distinguished
   on the BFP channel.[^43]
1. After setting voltages with control samples, run transduced samples from
   lowest viral to highest. Set the cytometer to record at least 10,000 events
   for each sample. Record %BFP-positive for each titration.
1. Create a plot showing volume of virus on the x-axis and %BFP-positive on the y-axis.[^44]
1. Calculate viral titer in titering units (TU) per \unit{\mL} using **Equation 1**
  using a pair of values within the linear region of the titer curve.[^45]

[^42]: Ensure proper controls for flow. Minimally have a positive control
  expressing BFP and a negative control expressing no fluorescent proteins.
[^43]: BFP populations will be normally distributed. For titer calculations,
  it is useful to set tight gates such that 99.98%
  of the negative control cells are captured in the negative gate.
[^44]: Plot will appear logarithmic. Only values within the linear region
  of the plot should be used to calculate viral titer (usually between 10-40% BFP-positive).
[^45]: Example: If 5 \unit{\uL} of virus added to 100,000 cells resulted
  in 30% BFP-positive cells within the linear region of the titer curve,
  then the viral titer would be (100,000 x 0.30) / (0.005 \unit{\mL}) = 6.0 x 10^6^ \unit{TU\per\mL}

$$\frac{\text{TU}}{\text{mL}}\text{=}\frac{\left(\text{Number of cells at time of transduction} \right)\text{ × }\left( \text{Fraction of Positive Cells} \right)}{\left( \text{Volume of virus }\left\lbrack \text{mL} \right\rbrack \right)}$$

## ClonMapper Viral Transduction

1. After calculating the viral titer (\unit{TU\per\mL}) on your cell line of interest,
  determine the final number of cells you require for your experiment using
  and transduce cells at a multiplicity of infection (MOI) of 0.1 (**Equation 2**)
  to minimize the occurrence of multiple barcode integrations.[^46]^,^[^47]
1. Use control samples to set laser voltages on FSC-A, SSC-A,
   and BFP such that nearly all cells are seen within FSC-A vs. SSC-A plot
   and both negative and positive .populations can be seen and distinguished
   on the BFP channel.[^42]
1. Set sort gate on BFP-positive cells indicative of a productive sgRNA barcode.[^48]
1. Sort cells on BFP-positive gate via FACS.
1. Maintain sorted cells in culture with complete growth medium.

$$\text{MOI [TU/cell] = }\frac{\left( \text{Volume of Virus needed [mL]} \right)\text{ × }\left( \text{Titer of Virus [TU/mL]} \right)}{\left( \text{Number of cells exposed to virus} \right)}\text{ = 0.1}$$

[^46]: Example: If your viral titer was 6.0 x 10^6^ \unit{TU\per\mL} and you wanted
  to infect 3.0 x 10^6^ cells at an MOI of 0.1, you would need to subject
  the 3.0 x 10^6^ cells to 50 \unit{\uL} of virus.
[^47]: A low MOI of 0.1 or below helps prevent occurrence
  of multiple barcode integrations. In order to uniquely recall cell lineages
  it is important to maximize the probability that there is one or zero barcodes
  per cell at the time of transduction. The probability of barcode integration
  can be modeled as a Poisson distribution [@fehse2004;@kustikova2003].
[^48]: When sorting for sgRNA barcoded cells, use more stringent gating than used
  for titer determination. Ensure that 0% of negative control samples appear in the sorting gate.


