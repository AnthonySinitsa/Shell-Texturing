# Shell-Texturing WIP

The first two iterations use the CPU to calculate positions of quads

The third iteration is a code overhaul that uses the GPU entirely(AKA even faster and efficienter)

#### Iteration 1
![Grass](image0.png)
#### Iteration 2
![Grass](image1.png)
#### Iteration 3
![Grass](image2.png)
#### Illusion of fur
![Ball](ball0.png)

### Steps Taken:
 
- Render quad

- Give quad a seed value that was outputted by a hash function

- if rng > 0.01, render green color: else black

- Quad is entirely green, essentially one big blade of grass

- To get more blades of grass  seed = ⌊uv * density⌋  (density being the width and height of the field)

- With a density of 100, we have a field of 100 x 100 blades of grass

- Draw another quad(with new quad uv oords being slightly higher than the the previous quad)

- Quad seed number will be the same which is good

- Now instead of if(rng > 0) do if(rng > NewQuadHeight)

- Draw 16 squares

- Now discard the black pixels and now we have "grass"

- To get some easy lighting just multiply the color * height^attenuation  (height of the quad)

- Now we can translate shell textured grass from a plane to any arbitrary mesh by extruding the shell out from the normal of the base vertex:

![vertexNormal](vertexNormal0.png)

- So for a sphere, draw a bunch of spheres on top of each other

- Then in the vertex shader, extrude the shells outwards from the normals based on desired distance: vertex.xyz += vertex.xyz * distance * height