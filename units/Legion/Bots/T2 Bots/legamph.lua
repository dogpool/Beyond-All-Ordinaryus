return {
	legamph = {
		activatewhenbuilt = true,
		brakerate = 0.5,
		buildpic = "LEGAMPH.DDS",
		buildtime = 19000,
		canmove = true,
		collisionvolumeoffsets = "0 -10 0",
		collisionvolumescales = "32 35 48",
		collisionvolumetype = "Box",
		corpse = "DEAD",
		damagemodifier = 0.5,
		energycost = 19000,
		explodeas = "smallExplosionGeneric-phib",
		footprintx = 2,
		footprintz = 2,
		health = 2750,
		idleautoheal = 5,
		idletime = 1800,
		maxacc = 0.1035,
		maxdec = 0.6486,
		maxslope = 14,
		metalcost = 660,
		movementclass = "HABOT5",
		nochasecategory = "VTOL",
		objectname = "Units/LEGAMPH.s3o",
		radardistance = 300,
		script = "Units/LEGAMPH.cob",
		seismicsignature = 0,
		selfdestructas = "smallExplosionGenericSelfd-phib",
		sightdistance = 450,
		sonardistance = 700,
		sonarstealth = false,
		speed = 48,
		turninplace = false,
		turninplaceanglelimit = 90,
		turninplacespeedlimit = 1.221,
		turnrate = 450,
		--usepiececollisionvolumes = 1,
		upright = false,
		customparams = {
			maxrange = 400,
			model_author = "Johanthan Crimson, Tuerk",
			normaltex = "unittextures/leg_normal.dds",
			paralyzemultiplier = 0.2,
			subfolder = "Legion/T2",
			techlevel = 2,
			unitgroup = "weaponsub",
			iswatervariable = true,
			waterspeed = 68,
		},
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "0 0 0",
				collisionvolumescales = "32 29 52",
				collisionvolumetype = "Box",
				damage = 1056,
				featuredead = "HEAP",
				footprintx = 3,
				footprintz = 3,
				height = 20,
				metal = 330,
				object = "Units/legamph_dead.s3o",
				reclaimable = true,
			},
			heap = {
				blocking = false,
				category = "heaps",
				collisionvolumescales = "35.0 4.0 6.0",
				collisionvolumetype = "cylY",
				damage = 920,
				footprintx = 2,
				footprintz = 2,
				height = 4,
				metal = 115,
				object = "Units/cor2X2D.s3o",
				reclaimable = true,
				resurrectable = 0,
			},
		},
		sfxtypes = {
			explosiongenerators = {
				[1] = "custom:selfrepair-sparks",
				[2] = "custom:subbubbles",
				[3] = "custom:footstep-medium",
			},
			pieceexplosiongenerators = {
				[1] = "deathceg2",
				[2] = "deathceg3",
				[3] = "deathceg4",
			},
		},
		sounds = {
			canceldestruct = "cancel2",
			underattack = "warning1",
			cant = {
				[1] = "cantdo4",
			},
			count = {
				[1] = "count6",
				[2] = "count5",
				[3] = "count4",
				[4] = "count3",
				[5] = "count2",
				[6] = "count1",
			},
			ok = {
				[1] = "kbcormov",
			},
			select = {
				[1] = "kbcorsel",
			},
		},
		weapondefs = {
			heat_ray = {
				areaofeffect = 64,
				avoidfeature = false,
				avoidfriendly = true,
				beamtime = 0.033,
				corethickness = 0.5,
				craterareaofeffect = 0,
				craterboost = 0,
				cratermult = 0,
				edgeeffectiveness = 0.15,
				energypershot = 300,
				explosiongenerator = "custom:heatray-large",
				firestarter = 30,
				firetolerance = 5000,
				impulsefactor = 0,
				laserflaresize = 6,
				name = "Heavy g2g Cleansing Heat Ray",
				noselfdamage = true,
				predictboost = 0.3,
				proximitypriority = 1,
				range = 400,
				reloadtime = 6,
				rgbcolor = "1 0.5 0",
				rgbcolor2 = "0.8 1.0 0.3",
				soundhitdry = "",
				soundhitwet = "sizzle",
				soundstart = "heatray3",
				soundstartvolume = 11,
				soundtrigger = 1,
				tolerance = 5000,
				thickness = 4.0,
				turret = true,
				weapontype = "BeamLaser",
				weaponvelocity = 950,
				damage = {
					default = 33,
					vtol = 10,
				},
				customparams = {
					sweepfire=4.5,--multiplier for displayed dps during the 'bonus' sweepfire stage, needed for DPS calcs
				}
			},
			coax_depthcharge = {
				areaofeffect = 32,
				avoidfeature = false,
				avoidfriendly = false,
				avoidground = false,
				bouncerebound = 0.6,
				bounceslip = 0.6,
				burnblow = true,
				collidefriendly = false,
				craterareaofeffect = 0,
				craterboost = 0,
				cratermult = 0,
				edgeeffectiveness = 0.15,
				explosiongenerator = "custom:genericshellexplosion-small-uw",
				flighttime = 1.75,
				gravityaffected = "true",
				groundbounce = true,
				impulsefactor = 0.123,
				model = "legbasictorpedo.s3o",
				mygravity = 0.2,
				name = "Depthcharge launcher",
				noselfdamage = true,
				numbounce = 1,
				range = 600,
				reloadtime = 3,
				soundhit = "xplodep2",
				soundhitvolume = 3,
				soundhitwet = "splsmed",
				soundhitwetvolume = 12,
				soundstart = "torpedo1",
				startvelocity = 190,
				tracks = true,
				trajectoryheight = 0.4,
				turnrate = 64000,
				turret = true,
				waterweapon = true,
				weaponacceleration = 75,
				weapontype = "TorpedoLauncher",
				weaponvelocity = 300,
				damage = {
					default = 350,
				},
			},
		},
		weapons = {
			[1] = {
				def = "HEAT_RAY",
				onlytargetcategory = "SURFACE",
				maxangledif = 120,
				maindir = "0 0 1"
			},
			[2] = {
				def = "COAX_DEPTHCHARGE",
				onlytargetcategory = "NOTHOVER",
			},
		},
	},
}
