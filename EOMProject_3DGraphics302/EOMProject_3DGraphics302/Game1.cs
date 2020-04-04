using EOMProject_3DGraphics302.Classes.Custom.Models;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Sample;
using System.Collections.Generic;

namespace EOMProject_3DGraphics302
{
    /// <summary>
    /// This is the main type for your game.
    /// </summary>
    public class Game1 : Game
    {
        GraphicsDeviceManager graphics;
        SpriteBatch spriteBatch;

        InputEngine input;
        DebugEngine debug;
        ImmediateShapeDrawer shapeDrawer;

        List<MixedLightModel> gameObjects = new List<MixedLightModel>();
        Camera mainCamera;

        //4K Render Variables
        RenderTarget2D FourK_RT;
        bool FourKToggle = false;
        SpriteFont debugFont;

        public Game1()
        {
            graphics = new GraphicsDeviceManager(this);
            graphics.PreferredBackBufferWidth = 1920;
            graphics.PreferredBackBufferHeight = 1080;
            graphics.GraphicsProfile = GraphicsProfile.HiDef;
            graphics.ApplyChanges();

            FourK_RT = new RenderTarget2D(GraphicsDevice,3820, 2160,false,SurfaceFormat.Color,DepthFormat.Depth24Stencil8);

            input = new InputEngine(this);
            debug = new DebugEngine();
            shapeDrawer = new ImmediateShapeDrawer();

            Window.AllowUserResizing = true;
            IsMouseVisible = true;

            Content.RootDirectory = "Content";
        }

        /// <summary>
        /// Initializes the model, loads relevant content and then adds gameobject to list.
        /// </summary>
        /// <param name="model"></param>
        void AddModel(MixedLightModel model)
        {
            model.Initialize();
            model.LoadContent();
            gameObjects.Add(model);
        }

        /// <summary>
        /// Allows the game to perform any initialization it needs to before starting to run.
        /// This is where it can query for any required services and load any non-graphic
        /// related content.  Calling base.Initialize will enumerate through any components
        /// and initialize them as well.
        /// </summary>
        protected override void Initialize()
        {
            // Game Utility Setup
            GameUtilities.Content = Content;
            GameUtilities.GraphicsDevice = GraphicsDevice;

            debug.Initialize();
            shapeDrawer.Initialize();

            //Camera setup
            mainCamera = new Camera("camera", new Vector3(0, 100, 400), new Vector3(0, 0, -1));
            mainCamera.Initialize();

            
            base.Initialize();
        }

        /// <summary>
        /// LoadContent will be called once per game and is the place to load
        /// all of your content.
        /// </summary>
        protected override void LoadContent()
        {
            spriteBatch = new SpriteBatch(GraphicsDevice);
            debugFont = Content.Load<SpriteFont>(@"Fonts\debug2");

            AddModel(new MixedLightModel("Model", Vector3.Zero)); 
        }

        /// <summary>
        /// UnloadContent will be called once per game and is the place to unload
        /// game-specific content.
        /// </summary>
        protected override void UnloadContent()
        {
            // TODO: Unload any non ContentManager content here
        }

        /// <summary>
        /// Allows the game to run logic such as updating the world,
        /// checking for collisions, gathering input, and playing audio.
        /// </summary>
        /// <param name="gameTime">Provides a snapshot of timing values.</param>
        protected override void Update(GameTime gameTime)
        {
            GameUtilities.Time = gameTime;

            if (InputEngine.IsKeyHeld(Keys.Escape))
                Exit();

            mainCamera.Update();

            //UpdateCamera used for specular due to camera position relevant to light
            gameObjects.ForEach(go => go.Update());
            gameObjects.ForEach(go => go.UpdateCamera(mainCamera.World.Translation));

            //Toggle Logic for 4K Rendering
            if (InputEngine.IsKeyPressed(Keys.R))
                FourKToggle = !FourKToggle;


            base.Update(gameTime);
        }

        /// <summary>
        /// This is called when the game should draw itself.
        /// </summary>
        /// <param name="gameTime">Provides a snapshot of timing values.</param>
        protected override void Draw(GameTime gameTime)
        {

            GraphicsDevice.Clear(Color.Black); //Using black to illustrate colors better

            if (!FourKToggle)
                GraphicsDevice.SetRenderTarget(null);
            else
            {
                GraphicsDevice.SetRenderTarget(FourK_RT);
                
                //Below lines needed to avoid backfaces being rendered in front of object during spritebatch draw
                GraphicsDevice.DepthStencilState = DepthStencilState.Default;
                GraphicsDevice.BlendState = BlendState.Opaque;
            }


            //Model Rendering
            foreach (CustomEffectModel model in gameObjects)
            {
                if (mainCamera.Frustum.Contains(model.AABB) != ContainmentType.Disjoint)
                {
                    model.Draw(mainCamera);
                }

            }

            debug.Draw(mainCamera);


            GraphicsDevice.SetRenderTarget(null);

            //4K spritebatch
            if (FourKToggle)
            {
                spriteBatch.Begin(SpriteSortMode.Immediate,BlendState.Opaque);
                spriteBatch.Draw(FourK_RT, GraphicsDevice.Viewport.Bounds, Color.White);
                spriteBatch.DrawString(debugFont,"Drawing @ 4K", new Vector2(10, 10), Color.White);
                spriteBatch.End();
            }

            GameUtilities.SetGraphicsDeviceFor3D();

            base.Draw(gameTime);
        }
    }
}
