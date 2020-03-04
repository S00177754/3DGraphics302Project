#if OPENGL
	#define SV_POSITION POSITION
	#define VS_SHADERMODEL vs_3_0
	#define PS_SHADERMODEL ps_3_0
#else
	#define VS_SHADERMODEL vs_4_0_level_9_1
	#define PS_SHADERMODEL ps_4_0_level_9_1
#endif

matrix World;
matrix View;
matrix Projection;

//Point Light
float3 PointLightPositions[2];
float3 PointLightAttenuations[2];
float3 PointLightColors[2];
float PointLightFallOff = 2; //Inverse square law

//Directional Light
float3 DirectionalLightColor = float3(1, 1, 1);
float3 DirectionalLightDirection = float3(0, 1, 0);

//Common
float3 AmbientColor = float3(.15, .15, .15);
float3 DiffuseColor = float3(1, 1, 1);
Texture2D DiffuseTextures[2];
Texture2D NormalTexture;
SamplerState TextureSamples[3];

//Samplers - Need to find a way to make into array
//sampler DiffuseTextureSamplerOne = sampler_state
//{
//    texture = <DiffuseTextures[0]>;
//};

//sampler DiffuseTextureSamplerTwo = sampler_state
//{
//    texture = <DiffuseTextures[1]>;
//};

//sampler NormalTextureSampler = sampler_state
//{
//    texture = <NormalTexture>;
//};

//Vertex Shader
struct VertexShaderInput
{
	float4 Position : POSITION0;
    float2 UV : TEXCOORD0;
    float3 Normal : NORMAL0;
};

struct VertexShaderOutput
{
	float4 Position : SV_POSITION;
    float2 UV : TEXCOORD0;
    float3 Normal : TEXCOORD1;
    float3 WorldPosition : TEXCOORD2;
    //float2 ViewDirection : TEXCOORD3;
};

VertexShaderOutput MainVS(in VertexShaderInput input)
{
	VertexShaderOutput output;

    float4 worldPos = mul(input.Position, World);
    float4 viewPos = mul(worldPos, View);

    output.Position = mul(viewPos, Projection);
    output.WorldPosition = worldPos;
    output.Normal = normalize(mul(input.Normal, World));
    output.UV = input.UV;
   
	return output;
}

//Light Creation Methods
float4 CreatePointLight(VertexShaderOutput input, int arrayIndex):COLOR
{
    float3 color = DiffuseColor; //Color of the object
    float3 lightingColor = AmbientColor; //Color when no light
    float3 lightDirection = normalize(PointLightPositions[arrayIndex] - input.WorldPosition);
    
    float3 angle = saturate(dot(input.Normal, lightDirection)); //No need for sampling normal?
    float distance = distance(PointLightPositions[arrayIndex], input.WorldPosition);
    float attenuation = 1 - pow(clamp(distance / PointLightAttenuations[arrayIndex], 0, 1), PointLightFallOff);
    
    lightingColor += angle * attenuation * PointLightColors[arrayIndex];
    
    return float4(color * lightingColor, 1);
}

float4 CreateDirectionalLight(VertexShaderOutput input):COLOR
{
    float3 color = DiffuseColor;
    color *= DiffuseTextures[0].Sample(TextureSamples[0], input.UV);
    
    float3 lightingColor = AmbientColor;
    float3 lightDirection = normalize(DirectionalLightDirection);
    
    float3 angle = saturate(dot(input.Normal, lightDirection));
    lightingColor += saturate(angle * color * DirectionalLightColor);
    
    return float4(lightingColor, 1);
   
}

//PixelShader
float4 MainPS(VertexShaderOutput input) : COLOR
{
	return 0;
}


technique BasicColorDrawing
{
	pass P0
	{
		VertexShader = compile VS_SHADERMODEL MainVS();
		PixelShader = compile PS_SHADERMODEL MainPS();
	}
};