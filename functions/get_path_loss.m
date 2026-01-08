function L = get_path_loss(dev1,dev2)

dist = get_relative_position(dev1.location,dev2.location);

lam = dev1.carrier_wavelength; % assumed same as dev2 (should be!)

L = ((4 * pi * dist) ./ lam).^2;

end