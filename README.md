# README
## RivetWizard
### Purpose
RivetWizard is a rivet-placement optimization tool written in MATLAB. RivetWizard finds great rivet placement configurations for lap joints to be put under axial tension. The types of failure to be accounted for are:
  * Tensile failure
  * Shear failure
  * Tear-out failure
  * Bearing Failure

### Output
#### Console Output
The results of optimization display the failure loads of each type from the configuration found with the highest minimum failure load with units in *pound-force*.

The failure loads are anteceded by the coordinates of the center-points of each rivet-hole in *inches*. The coordinate system origin is the corner of the imaginary rectangle created by the overlapping stock.

Here is an example of what the command line output might look like with a selected accuracy of 1/16 in:
```
Tensile: 5373.88	Shear: 5900.00	Tear: 8316.63	Bearing: 6190.81

(0.312500, 0.500000)
(0.312500, 1.000000)
(0.687500, 0.125000)
(0.812500, 1.062500)
(0.875000, 1.562500)
(1.187500, 0.187500)
(1.187500, 0.687500)
(1.375000, 1.625000)
(1.687500, 0.750000)
(1.750000, 1.250000)
```
#### Graphical Output
The program also outputs a diagram to show what the best configuration found would look like. Here is an example image.
![alt text](https://github.com/MarcianoPreciado/RivetWizard/Images/OutputGraph.png "Example Output Diagram")
